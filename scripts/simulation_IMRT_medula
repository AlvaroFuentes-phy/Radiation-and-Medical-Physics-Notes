clear; clc; close all;

%% 1. CONFIGURACIÓN DEL ESPACIO Y FANTOMA (ANATOMÍA)
% -------------------------------------------------------------------------
N = 60; % Resolución de la cuadrícula (N x N)
[X, Y] = meshgrid(linspace(-10, 10, N));
radio_medula = 2.0;
radio_cuerpo = 8.0;

% Definición de máscaras lógicas (1 = pertenece a la estructura, 0 = no)
target_mask = (X.^2 + Y.^2) <= radio_medula^2; % Médula (Target)
body_mask = (X.^2 + Y.^2) <= radio_cuerpo^2;
oar_mask = body_mask & ~target_mask; % Tejido sano circundante (Órganos de Riesgo)

% Vectorizamos las máscaras para facilitar el cálculo matricial
idx_target = find(target_mask);
idx_oar = find(oar_mask);
num_voxels = N * N;

%% 2. MODELADO DE HACES Y MATRIZ DE INFLUENCIA (A)
% -------------------------------------------------------------------------
angulos = 0:72:359; % 5 campos de entrada (grados)
num_angulos = length(angulos);
ancho_haz = 15; % Número de beamlets por ángulo
total_beamlets = num_angulos * ancho_haz;

% A es la matriz de influencia: [voxels x beamlets]
A = zeros(num_voxels, total_beamlets);

disp('Calculando matriz de influencia geométrica...');
beamlet_idx = 1;
for ang = angulos
    for b = 1:ancho_haz
        % Simulación simplificada de un beamlet como una línea recta con atenuación
        pos_x = (b - ancho_haz/2) * 0.8; % Desplazamiento lateral del beamlet
        
        % Matriz temporal para el beamlet en ángulo 0
        beam_2d = zeros(N, N);
        distancia_centro = abs(X - pos_x);
        
        % Perfil del haz (Gaussiano para simular penumbra física)
        perfil = exp(-(distancia_centro.^2) / (2 * 0.5^2)); 
        beam_2d(Y < 0 | body_mask) = perfil(Y < 0 | body_mask); 
        
        % Rotar el beamlet al ángulo correspondiente de entrada
        beam_rotado = imrotate(beam_2d, ang, 'bilinear', 'crop');
        
        % Atenuación básica simulada (Ley de Beer-Lambert aproximada)
        A(:, beamlet_idx) = beam_rotado(:);
        beamlet_idx = beamlet_idx + 1;
    end
end

%% 3. OPTIMIZACIÓN DEL PLAN (INVERSE PLANNING)
% -------------------------------------------------------------------------
% Definimos la dosis prescrita y los pesos de importancia (Penalizaciones)
dosis_prescrita = 60; % Gy a la médula
peso_target = 10.0;   % Prioridad para cubrir el blanco
peso_oar = 1.0;       % Prioridad para proteger tejido sano

% Construcción de matrices para lsqnonneg (Aw = b)
% Separamos las filas de A según pertenezcan al Target o al OAR
A_opt = [peso_target * A(idx_target, :); 
         peso_oar * A(idx_oar, :)];

% Vector objetivo (b)
b_opt = [peso_target * dosis_prescrita * ones(length(idx_target), 1); 
         zeros(length(idx_oar), 1)];

disp('Optimizando pesos de los haces (Resolviendo matriz)...');
% Minimiza ||A_opt*w - b_opt||^2 sujeto a w >= 0
options = optimset('Display', 'off');
w_opt = lsqnonneg(A_opt, b_opt, options); 

%% 4. CÁLCULO DE DOSIS FINAL Y VISUALIZACIÓN
% -------------------------------------------------------------------------
% Dosis final en cada voxel (D = A * w)
D_vector = A * w_opt;
Dosis_2D = reshape(D_vector, N, N);
Dosis_2D(~body_mask) = 0; % Limpiar fuera del cuerpo

% --- GRÁFICA 1: Mapa de Dosis (Isodosis) ---
figure('Name', 'Resultados Simulación IMRT', 'Position', [100, 100, 1000, 400]);

subplot(1,2,1);
imagesc(linspace(-10,10,N), linspace(-10,10,N), Dosis_2D);
colormap(jet); colorbar; hold on;
% Dibujar contornos de las estructuras
contour(X, Y, target_mask, [1 1], 'k', 'LineWidth', 2); % Médula en negro
title('Distribución de Dosis (Gy)');
xlabel('Eje X (cm)'); ylabel('Eje Y (cm)');
axis square; hold off;

% --- GRÁFICA 2: Histograma Dosis-Volumen (DVH) ---
% El DVH evalúa la calidad clínica del plan
subplot(1,2,2);
dosis_target = Dosis_2D(target_mask);
dosis_oar = Dosis_2D(oar_mask);

[count_t, edges_t] = histcounts(dosis_target, 50);
[count_o, edges_o] = histcounts(dosis_oar, 50);

vol_target = cumsum(count_t, 'reverse') / sum(count_t) * 100;
vol_oar = cumsum(count_o, 'reverse') / sum(count_o) * 100;

plot(edges_t(1:end-1), vol_target, 'r', 'LineWidth', 2); hold on;
plot(edges_o(1:end-1), vol_oar, 'b', 'LineWidth', 2);
title('Histograma Dosis-Volumen (DVH)');
xlabel('Dosis (Gy)'); ylabel('Volumen (%)');
legend('Médula (Target)', 'Tejido Sano (OAR)');
grid on; axis([0 max(Dosis_2D(:))*1.1 0 100]);
