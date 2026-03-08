% Este script implementa la fórmula semiempírica de masa de Weizsäcker-Bohr,
% también conocida como el modelo de la gota líquida. Esta fórmula empírica
% predice la energía de enlace de un núcleo atómico basándose en cinco 
% términos físicos fundamentales:
%
% FÓRMULA MATEMÁTICA:
% B(A,Z) = a_v·A - a_s·A^(2/3) - a_c·Z²/A^(1/3) - a_a·(A-2Z)²/A + δ(A,Z)
%
% Donde:
%   A = Número másico (protones + neutrones)
%   Z = Número atómico (protones)
%   N = Número de neutrones (N = A - Z)
%
% TÉRMINOS DE LA FÓRMULA:
%
% 1. TÉRMINO DE VOLUMEN (a_v·A):
%    Representa la energía de enlace proporcional al número de nucleones.
%    Análogo a la cohesión en una gota líquida. Cada nucleón contribuye
%    aproximadamente 15.75 MeV a la energía de enlace total.
%
% 2. TÉRMINO DE SUPERFICIE (-a_s·A^(2/3)):
%    Corrección negativa porque los nucleones en la superficie del núcleo
%    tienen menos vecinos y por tanto menor energía de enlace. Proporcional
%    al área superficial (A^(2/3)).
%
% 3. TÉRMINO COULOMBIANO (-a_c·Z²/A^(1/3)):
%    Representa la repulsión electrostática entre protones. Reduce la
%    estabilidad en núcleos pesados con muchos protones.
%
% 4. TÉRMINO DE ASIMETRÍA (-a_a·(A-2Z)²/A):
%    Penaliza núcleos con exceso de neutrones o protones. Los núcleos
%    más estables tienen N ≈ Z para núcleos ligeros, y N > Z para pesados.
%
% 5. TÉRMINO DE APAREAMIENTO (δ(A,Z)):
%    Representa el efecto cuántico de apareamiento de nucleones:
%    - Positivo para par-par (Z y N ambos pares)
%    - Negativo para impar-impar (Z y N ambos impares)
%    - Cero para par-impar o impar-par
%
% PARÁMETROS EMPÍRICOS (en MeV):
%   a_v = 15.75  (volumen)
%   a_s = 17.8   (superficie)
%   a_c = 0.711  (coulomb)
%   a_a = 23.7   (asimetría)
%   a_p = 11.18  (apareamiento)
%
% =========================================================================
% VISUALIZACIONES GENERADAS
% =========================================================================
%
% FIGURA 1: Energía de Enlace por Nucleón vs. Número Másico
%   - Muestra la curva de estabilidad nuclear
%   - Identifica el pico en Fe-56 (máxima estabilidad)
%   - Marca 23 núcleos importantes con código de colores
%
% FIGURA 2: Contribuciones de Cada Término
%   - Subplot superior: Contribuciones individuales de cada término
%   - Subplot inferior: Contribución acumulada mostrando el efecto neto
%
% FIGURA 3: Valle de Estabilidad Nuclear
%   - Mapa de calor 2D (Z vs. A)
%   - Muestra números mágicos (2, 8, 20, 28, 50)
%   - Identifica núcleos doblemente mágicos
%
% FIGURA 4: Análisis de Fisión y Fusión
%   - Comparación de estabilidad entre núcleos seleccionados
%   - Energía liberada en fisión de U-235
%   - Energía liberada en fusión D-T → He-4
%   - Relación N/Z para línea de estabilidad
%
% TABLA DE RESULTADOS:
%   - 30 núcleos importantes desde Deuterio hasta Plutonio-239
%   - Columnas: A, Z, BE total, BE/A, ratio N/Z
%   - Estadísticas y observaciones físicas
%
% =========================================================================
% APLICACIONES FÍSICAS
% =========================================================================
%
% Esta fórmula permite:
% - Predecir la estabilidad de núcleos conocidos y desconocidos
% - Calcular energía liberada en reacciones nucleares
% - Entender por qué el hierro-56 es el núcleo más estable
% - Explicar por qué la fusión libera energía en núcleos ligeros
% - Explicar por qué la fisión libera energía en núcleos pesados
% - Identificar el valle de estabilidad nuclear
%
% =========================================================================
% REFERENCIAS
% =========================================================================
%
% Weizsäcker, C. F. von. (1935). Zur Theorie der Kernmassen. 
%     Zeitschrift für Physik, 96(7-8), 431-458.
%
% Bohr, N., & Wheeler, J. A. (1939). The mechanism of nuclear fission. 
%     Physical Review, 56(5), 426-450.
%
% Krane, K. S. (1988). Introductory nuclear physics. 
%     John Wiley & Sons.
%
% =========================================================================

clear all; close all; clc;

%% Parámetros de la fórmula (en MeV)
a_volumen = 15.75;      % Término de volumen
a_superficie = 17.8;    % Término de superficie
a_coulomb = 0.711;      % Término coulombiano
a_asimetria = 23.7;     % Término de asimetría
a_apareamiento = 11.18; % Término de apareamiento

%% Función de apareamiento δ(A,Z)
termino_apareamiento = @(A, Z) a_apareamiento * (mod(Z,2)==0 && mod(A-Z,2)==0) / sqrt(A) - ...
                                a_apareamiento * (mod(Z,2)==1 && mod(A-Z,2)==1) / sqrt(A);

%% Fórmula de Weizsäcker-Bohr
energia_enlace_total = @(A, Z) a_volumen*A - a_superficie*A^(2/3) - a_coulomb*Z^2/A^(1/3) - ...
                               a_asimetria*(A-2*Z)^2/A + termino_apareamiento(A, Z);

%% Energía de enlace por nucleón
energia_enlace_por_nucleon = @(A, Z) energia_enlace_total(A, Z) / A;

%% 1. Gráfica de energía de enlace por nucleón vs. número másico
figure(1);
set(gcf, 'Position', [100, 100, 1200, 700]);

rango_A = 1:240;
energia_por_nucleon = zeros(size(rango_A));

for i = 1:length(rango_A)
    A = rango_A(i);
    Z = round(A / 2); % Aproximación: Z ≈ A/2 para núcleos estables
    energia_por_nucleon(i) = energia_enlace_por_nucleon(A, Z);
end

% Fondo con gradiente
area(rango_A, energia_por_nucleon, 'FaceColor', [0.7 0.85 1], 'EdgeColor', 'none', 'FaceAlpha', 0.3);
hold on;
plot(rango_A, energia_por_nucleon, 'b-', 'LineWidth', 2.5);
grid on;
xlabel('Número másico (\itA\rm)', 'FontSize', 14);
ylabel('Energía de enlace por nucleón (MeV)', 'FontSize', 14);
title('Energía de enlace por nucleón en función del número másico', 'FontSize', 16);
set(gca, 'FontSize', 12, 'LineWidth', 1.5);

% Núcleos importantes - expandida la lista
nucleos_importantes = [
    2, 1;     % H-2 (Deuterio)
    3, 2;     % He-3
    4, 2;     % He-4 (Partícula alfa)
    6, 3;     % Li-6
    7, 3;     % Li-7
    9, 4;     % Be-9
    12, 6;    % C-12 (Estándar)
    14, 7;    % N-14
    16, 8;    % O-16
    20, 10;   % Ne-20
    27, 13;   % Al-27
    32, 16;   % S-32
    40, 20;   % Ca-40
    56, 26;   % Fe-56 (Máxima estabilidad)
    59, 27;   % Co-59
    64, 29;   % Cu-64
    90, 40;   % Zr-90
    119, 50;  % Sn-119
    138, 56;  % Ba-138
    197, 79;  % Au-197
    208, 82;  % Pb-208 (Doblemente mágico)
    235, 92;  % U-235 (Fisible)
    238, 92   % U-238
];

nombres_importantes = {'^2H', '^3He', '^4He', '^6Li', '^7Li', '^9Be', '^{12}C', ...
                       '^{14}N', '^{16}O', '^{20}Ne', '^{27}Al', '^{32}S', '^{40}Ca', ...
                       '^{56}Fe', '^{59}Co', '^{64}Cu', '^{90}Zr', '^{119}Sn', '^{138}Ba', ...
                       '^{197}Au', '^{208}Pb', '^{235}U', '^{238}U'};

% Colores diferentes para categorías
colores_categorias = [
    0.9 0.2 0.2;  % Ligeros (A<20) - Rojo
    0.2 0.7 0.2;  % Medios (20≤A<100) - Verde
    0.2 0.2 0.9;  % Pesados (A≥100) - Azul
];

for i = 1:size(nucleos_importantes, 1)
    A = nucleos_importantes(i, 1);
    Z = nucleos_importantes(i, 2);
    energia_BE = energia_enlace_por_nucleon(A, Z);
    
    % Seleccionar color según masa
    if A < 20
        color_nucleo = colores_categorias(1,:);
        tamanio_marcador = 10;
    elseif A < 100
        color_nucleo = colores_categorias(2,:);
        tamanio_marcador = 12;
    else
        color_nucleo = colores_categorias(3,:);
        tamanio_marcador = 11;
    end
    
    % Destacar Fe-56 y Pb-208
    if A == 56
        tamanio_marcador = 16;
        color_nucleo = [1 0.5 0]; % Naranja
    elseif A == 208
        tamanio_marcador = 14;
        color_nucleo = [0.5 0 0.5]; % Púrpura
    end
    
    plot(A, energia_BE, 'o', 'MarkerSize', tamanio_marcador, 'MarkerFaceColor', color_nucleo, ...
         'MarkerEdgeColor', 'k', 'LineWidth', 1.5);
    
    % Etiquetas optimizadas
    if A == 56
        text(A-5, energia_BE+0.7, nombres_importantes{i}, 'FontSize', 11, ...
             'BackgroundColor', [1 1 0.8], 'EdgeColor', 'k', 'Interpreter', 'tex');
    elseif A == 208 || A == 4 || A == 238
        text(A+3, energia_BE-0.3, nombres_importantes{i}, 'FontSize', 10, ...
             'BackgroundColor', [1 1 0.9], 'Interpreter', 'tex');
    elseif mod(i, 3) == 0  % Mostrar solo algunos nombres para no saturar
        text(A+2, energia_BE+0.2, nombres_importantes{i}, 'FontSize', 9, 'Interpreter', 'tex');
    end
end

% Líneas de referencia
yline(8, '--k', 'LineWidth', 1, 'Alpha', 0.5);
text(200, 8.2, '8 MeV/nucleón', 'FontSize', 10, 'Color', [0.3 0.3 0.3]);

hold off;
legend('Región de enlace', 'BE/\itA \rmteórico', 'Location', 'southeast', 'FontSize', 11);
ylim([0 10]);

%% 2. Contribuciones de cada término
figure(2);
set(gcf, 'Position', [150, 150, 1200, 700]);

rango_A = 1:240;
termino_volumen = zeros(size(rango_A));
termino_superficie = zeros(size(rango_A));
termino_coulomb = zeros(size(rango_A));
termino_asimetria = zeros(size(rango_A));

for i = 1:length(rango_A)
    A = rango_A(i);
    Z = round(A / 2);
    
    termino_volumen(i) = a_volumen * A / A;
    termino_superficie(i) = -a_superficie * A^(2/3) / A;
    termino_coulomb(i) = -a_coulomb * Z^2 / A^(4/3);
    termino_asimetria(i) = -a_asimetria * (A-2*Z)^2 / A^2;
end

% Subplot superior - Contribuciones individuales
subplot(2,1,1);
plot(rango_A, termino_volumen, '-', 'Color', [0 0.4 0.8], 'LineWidth', 2.5); hold on;
plot(rango_A, termino_superficie, '-', 'Color', [0.8 0.2 0.2], 'LineWidth', 2.5);
plot(rango_A, termino_coulomb, '-', 'Color', [0.2 0.7 0.2], 'LineWidth', 2.5);
plot(rango_A, termino_asimetria, '-', 'Color', [0.8 0.5 0], 'LineWidth', 2.5);
plot(rango_A, zeros(size(rango_A)), 'k--', 'LineWidth', 1);
grid on;
xlabel('Número másico (\itA\rm)', 'FontSize', 13);
ylabel('Contribución por nucleón (MeV)', 'FontSize', 13);
title('Contribuciones individuales de cada término de la fórmula SEMF', 'FontSize', 15);
legend('Volumen (+)', 'Superficie (−)', 'Coulomb (−)', 'Asimetría (−)', ...
       'Location', 'best', 'FontSize', 12);
set(gca, 'FontSize', 11, 'LineWidth', 1.5);
ylim([-6 17]);
hold off;

% Subplot inferior - Contribución acumulada
subplot(2,1,2);
energia_total_por_nucleon = termino_volumen + termino_superficie + termino_coulomb + termino_asimetria;
area(rango_A, termino_volumen, 'FaceColor', [0 0.4 0.8], 'FaceAlpha', 0.4, 'EdgeColor', 'none'); hold on;
area(rango_A, termino_volumen + termino_superficie, 'FaceColor', [0.8 0.2 0.2], 'FaceAlpha', 0.4, 'EdgeColor', 'none');
plot(rango_A, energia_total_por_nucleon, 'k-', 'LineWidth', 3);
grid on;
xlabel('Número másico (\itA\rm)', 'FontSize', 13);
ylabel('BE/\itA \rm(MeV)', 'FontSize', 13);
title('Energía de enlace acumulada por término', 'FontSize', 15);
legend('Volumen', 'Volumen + Superficie', 'BE/\itA \rmtotal', 'Location', 'southeast', 'FontSize', 12);
set(gca, 'FontSize', 11, 'LineWidth', 1.5);
hold off;

%% 3. Valle de estabilidad (Carta de nucleidos)
figure(3);
set(gcf, 'Position', [200, 200, 1200, 800]);

A_max = 140;
Z_max = 70;
matriz_energia = zeros(A_max, Z_max);

for A = 1:A_max
    for Z = 1:min(Z_max, A)
        if Z <= A
            matriz_energia(A, Z) = energia_enlace_por_nucleon(A, Z);
        else
            matriz_energia(A, Z) = NaN;
        end
    end
end

% Crear mapa de colores personalizado: blanco para 0, jet para valores positivos
mapa_colores = [1 1 1; jet(256)];  % Blanco + jet
colormap(mapa_colores);

% Reemplazar valores cero con NaN para que se vean blancos
matriz_energia(matriz_energia == 0) = NaN;

% Crear visualización mejorada
imagesc(1:Z_max, 1:A_max, matriz_energia);
barra_colores = colorbar('FontSize', 12, 'LineWidth', 1.5);
ylabel(barra_colores, 'Energía de enlace por nucleón (MeV)', 'FontSize', 11);
xlabel('Número atómico (\itZ\rm)', 'FontSize', 14);
ylabel('Número másico (\itA\rm)', 'FontSize', 14);
title('Valle de estabilidad nuclear: carta de nucleidos', 'FontSize', 16);
set(gca, 'YDir', 'normal', 'FontSize', 12, 'LineWidth', 1.5);
caxis([0 9]);

% Líneas de estabilidad
hold on;
plot(1:Z_max, 2*(1:Z_max), 'w--', 'LineWidth', 2.5);
text(35, 80, 'Línea \itN\rm = \itZ', 'Color', 'white', 'FontSize', 14, ...
     'BackgroundColor', [0 0 0 0.5]);

% Marcar números mágicos
numeros_magicos = [2, 8, 20, 28, 50];
for num_magico = numeros_magicos
    if num_magico <= Z_max
        xline(num_magico, 'w:', 'LineWidth', 2, 'Alpha', 0.7);
        yline(num_magico*2, 'w:', 'LineWidth', 2, 'Alpha', 0.7);
    end
end

% Marcar núcleos doblemente mágicos y otros importantes
nucleos_especiales = [
    4, 2;     % He-4
    16, 8;    % O-16
    40, 20;   % Ca-40
    48, 20;   % Ca-48
    56, 26;   % Fe-56
    208, 82;  % Pb-208
];

nombres_especiales = {'^4He', '^{16}O', '^{40}Ca', '^{48}Ca', '^{56}Fe', '^{208}Pb'};

for i = 1:size(nucleos_especiales, 1)
    A = nucleos_especiales(i, 1);
    Z = nucleos_especiales(i, 2);
    if Z <= Z_max && A <= A_max
        plot(Z, A, 'wo', 'MarkerSize', 12, 'MarkerFaceColor', 'yellow', ...
             'LineWidth', 2);
        text(Z+2, A+2, nombres_especiales{i}, 'Color', 'white', ...
             'FontSize', 10, 'BackgroundColor', [0 0 0 0.6], ...
             'Interpreter', 'tex');
    end
end

text(5, 130, 'Números mágicos: 2, 8, 20, 28, 50', 'Color', 'white', ...
     'FontSize', 11, 'BackgroundColor', [0 0 0 0.5]);

hold off;

%% 4. Análisis de fisión y fusión nuclear
figure(4);
set(gcf, 'Position', [250, 250, 1200, 800]);

% Subplot 1: Comparación de núcleos seleccionados
subplot(2,2,1);
nucleos_comparacion = [4, 12, 16, 27, 56, 90, 119, 138, 197, 208, 235, 238];
energia_comparacion = zeros(size(nucleos_comparacion));
nombres_comparacion = {'^4He', '^{12}C', '^{16}O', '^{27}Al', '^{56}Fe', '^{90}Zr', ...
                       '^{119}Sn', '^{138}Ba', '^{197}Au', '^{208}Pb', '^{235}U', '^{238}U'};

for i = 1:length(nucleos_comparacion)
    A = nucleos_comparacion(i);
    Z = round(A/2);
    if A > 100
        Z = round(A/2.4); % Mejor aproximación para núcleos pesados
    end
    energia_comparacion(i) = energia_enlace_por_nucleon(A, Z);
end

bar(energia_comparacion, 'FaceColor', [0.2 0.6 0.8], 'EdgeColor', 'k', 'LineWidth', 1.5);
set(gca, 'XTickLabel', nombres_comparacion, 'XTickLabelRotation', 45, 'TickLabelInterpreter', 'tex');
ylabel('BE/\itA \rm(MeV)', 'FontSize', 12);
title('Comparación de estabilidad nuclear', 'FontSize', 13);
grid on;
ylim([7 9]);
hold on;
yline(mean(energia_comparacion), '--r', 'Promedio', 'LineWidth', 2);
hold off;

% Subplot 2: Energía liberada en fisión
subplot(2,2,2);
% Fisión de U-235 → productos típicos
A_U235 = 235;
Z_U235 = 92;
energia_U235 = energia_enlace_por_nucleon(A_U235, Z_U235);

% Productos de fisión típicos (distribución bimodal)
productos_fision = [95, 140]; % Masas típicas de productos
Z_productos = [38, 54]; % Z aproximados
energia_productos = zeros(size(productos_fision));

for i = 1:length(productos_fision)
    energia_productos(i) = energia_enlace_por_nucleon(productos_fision(i), Z_productos(i));
end

categorias_fision = {'^{235}U (inicial)', 'Producto 1 (\itA\rm ≈ 95)', 'Producto 2 (\itA\rm ≈ 140)'};
valores_fision = [energia_U235, energia_productos];
colores_fision = [0.8 0.3 0.3; 0.3 0.8 0.3; 0.3 0.8 0.3];

for i = 1:length(valores_fision)
    bar(i, valores_fision(i), 'FaceColor', colores_fision(i,:), 'EdgeColor', 'k', 'LineWidth', 1.5);
    hold on;
end

set(gca, 'XTick', 1:3, 'XTickLabel', categorias_fision, 'TickLabelInterpreter', 'tex');
ylabel('BE/\itA \rm(MeV)', 'FontSize', 12);
title('Fisión nuclear: ^{235}U', 'FontSize', 13, 'Interpreter', 'tex');
grid on;

% Energía liberada
energia_liberada_fision = (mean(energia_productos) - energia_U235) * A_U235;
text(2, 8.2, sprintf('Energía liberada\n≈ %.0f MeV', energia_liberada_fision), ...
     'FontSize', 11, 'BackgroundColor', [1 1 0.8], ...
     'HorizontalAlignment', 'center');
hold off;

% Subplot 3: Energía liberada en fusión
subplot(2,2,3);
% Fusión D-T → He-4
A_deuterio = 2; Z_deuterio = 1;  % Deuterio
A_tritio = 3; Z_tritio = 1;      % Tritio
A_helio = 4; Z_helio = 2;        % Helio-4

energia_deuterio = energia_enlace_por_nucleon(A_deuterio, Z_deuterio);
energia_tritio = energia_enlace_por_nucleon(A_tritio, Z_tritio);
energia_helio = energia_enlace_por_nucleon(A_helio, Z_helio);

categorias_fusion = {'Deuterio (^2H)', 'Tritio (^3H)', 'Helio-4 (^4He)'};
valores_fusion = [energia_deuterio, energia_tritio, energia_helio];
colores_fusion = [0.8 0.6 0.3; 0.8 0.6 0.3; 0.3 0.6 0.8];

for i = 1:length(valores_fusion)
    bar(i, valores_fusion(i), 'FaceColor', colores_fusion(i,:), 'EdgeColor', 'k', 'LineWidth', 1.5);
    hold on;
end

set(gca, 'XTick', 1:3, 'XTickLabel', categorias_fusion, 'TickLabelInterpreter', 'tex');
ylabel('BE/\itA \rm(MeV)', 'FontSize', 12);
title('Fusión nuclear: ^2H + ^3H → ^4He', 'FontSize', 13, 'Interpreter', 'tex');
grid on;

% Energía liberada por nucleón
energia_promedio_inicial = (energia_deuterio * A_deuterio + energia_tritio * A_tritio) / (A_deuterio + A_tritio);
energia_liberada_fusion = (energia_helio - energia_promedio_inicial) * A_helio;
text(2, 6, sprintf('Energía liberada\n≈ %.1f MeV', energia_liberada_fusion), ...
     'FontSize', 11, 'BackgroundColor', [1 1 0.8], ...
     'HorizontalAlignment', 'center');
hold off;

% Subplot 4: Relación N/Z para estabilidad
subplot(2,2,4);
rango_A_estabilidad = 1:240;
Z_estable = zeros(size(rango_A_estabilidad));
N_estable = zeros(size(rango_A_estabilidad));

for i = 1:length(rango_A_estabilidad)
    A = rango_A_estabilidad(i);
    if A < 40
        Z_estable(i) = round(A/2);
    else
        Z_estable(i) = round(A/(2 + 0.0015*A)); % Aproximación empírica
    end
    N_estable(i) = A - Z_estable(i);
end

plot(Z_estable, N_estable, 'b-', 'LineWidth', 2.5); hold on;
plot(Z_estable, Z_estable, 'r--', 'LineWidth', 2); % Línea N=Z
grid on;
xlabel('Número de protones (\itZ\rm)', 'FontSize', 12);
ylabel('Número de neutrones (\itN\rm)', 'FontSize', 12);
title('Línea de estabilidad nuclear', 'FontSize', 13);
legend('Valle de estabilidad', 'Línea \itN \rm= \itZ', 'Location', 'northwest', 'FontSize', 11);

% Marcar regiones
text(20, 50, 'Exceso de neutrones para estabilidad', 'FontSize', 10, ...
     'BackgroundColor', [1 1 0.9]);
hold off;

%% 5. Cálculos específicos para núcleos importantes
fprintf('\n');
fprintf('═════════════════════════════════════════════════════════════════════════\n');
fprintf('    ENERGÍAS DE ENLACE - FÓRMULA SEMIEMPÍRICA DE MASA (SEMF)\n');
fprintf('═════════════════════════════════════════════════════════════════════════\n\n');

nucleos_tabla = [
    2, 1;      % H-2 (Deuterio)
    3, 2;      % He-3
    4, 2;      % He-4 (Partícula alfa)
    6, 3;      % Li-6
    7, 3;      % Li-7
    9, 4;      % Be-9
    12, 6;     % C-12 (Estándar de masa atómica)
    14, 7;     % N-14
    16, 8;     % O-16 (Doblemente mágico)
    20, 10;    % Ne-20
    27, 13;    % Al-27
    32, 16;    % S-32
    40, 18;    % Ar-40
    40, 20;    % Ca-40 (Doblemente mágico)
    48, 20;    % Ca-48 (Doblemente mágico)
    56, 26;    % Fe-56 (Máxima estabilidad)
    59, 27;    % Co-59
    63, 29;    % Cu-63
    64, 29;    % Cu-64
    90, 40;    % Zr-90
    107, 47;   % Ag-107
    119, 50;   % Sn-119
    127, 53;   % I-127
    138, 56;   % Ba-138
    197, 79;   % Au-197
    208, 82;   % Pb-208 (Doblemente mágico)
    232, 90;   % Th-232
    235, 92;   % U-235 (Fisible)
    238, 92;   % U-238
    239, 94    % Pu-239 (Fisible)
];

nombres_tabla = {
    'Deuterio (²H)', 'Helio-3 (³He)', 'Helio-4 (⁴He)', 'Litio-6 (⁶Li)', ...
    'Litio-7 (⁷Li)', 'Berilio-9 (⁹Be)', 'Carbono-12 (¹²C)★', 'Nitrógeno-14 (¹⁴N)', ...
    'Oxígeno-16 (¹⁶O)★★', 'Neón-20 (²⁰Ne)', 'Aluminio-27 (²⁷Al)', 'Azufre-32 (³²S)', ...
    'Argón-40 (⁴⁰Ar)', 'Calcio-40 (⁴⁰Ca)★★', 'Calcio-48 (⁴⁸Ca)★★', ...
    'Hierro-56 (⁵⁶Fe) MÁX', 'Cobalto-59 (⁵⁹Co)', 'Cobre-63 (⁶³Cu)', ...
    'Cobre-64 (⁶⁴Cu)', 'Zirconio-90 (⁹⁰Zr)', 'Plata-107 (¹⁰⁷Ag)', ...
    'Estaño-119 (¹¹⁹Sn)', 'Yodo-127 (¹²⁷I)', 'Bario-138 (¹³⁸Ba)', ...
    'Oro-197 (¹⁹⁷Au)', 'Plomo-208 (²⁰⁸Pb)★★', 'Torio-232 (²³²Th)', ...
    'Uranio-235 (²³⁵U)', 'Uranio-238 (²³⁸U)', 'Plutonio-239 (²³⁹Pu)'
};

fprintf('%-24s | %4s | %3s | %11s | %11s | %8s\n', ...
        'Núcleo', 'A', 'Z', 'BE (MeV)', 'BE/A (MeV)', 'N/Z');
fprintf('─────────────────────────┼──────┼─────┼─────────────┼─────────────┼─────────\n');

for i = 1:size(nucleos_tabla, 1)
    A = nucleos_tabla(i, 1);
    Z = nucleos_tabla(i, 2);
    N = A - Z;
    energia_total = energia_enlace_total(A, Z);
    energia_por_nuc = energia_enlace_por_nucleon(A, Z);
    razon_N_Z = N / Z;
    
    fprintf('%-24s | %4d | %3d | %11.2f | %11.3f | %8.3f\n', ...
            nombres_tabla{i}, A, Z, energia_total, energia_por_nuc, razon_N_Z);
end

fprintf('═════════════════════════════════════════════════════════════════════════\n');
fprintf('Leyenda:\n');
fprintf('  ★   = Estándar de referencia (¹²C para masas atómicas)\n');
fprintf('  ★★  = Núcleo doblemente mágico (Z y N son números mágicos)\n');
fprintf('  MÁX = Máxima energía de enlace por nucleón\n');
fprintf('═════════════════════════════════════════════════════════════════════════\n\n');

% Estadísticas adicionales
fprintf('OBSERVACIONES FÍSICAS:\n');
fprintf('─────────────────────────────────────────────────────────────────────────\n');

% Encontrar el núcleo más estable
energia_maxima = -inf;
indice_max = 0;
for i = 1:size(nucleos_tabla, 1)
    A = nucleos_tabla(i, 1);
    Z = nucleos_tabla(i, 2);
    energia = energia_enlace_por_nucleon(A, Z);
    if energia > energia_maxima
        energia_maxima = energia;
        indice_max = i;
    end
end

fprintf('• Núcleo más estable: %s con BE/A = %.3f MeV\n', ...
        nombres_tabla{indice_max}, energia_maxima);
fprintf('• El ⁵⁶Fe presenta la máxima energía de enlace por nucleón (~8.8 MeV)\n');
fprintf('• Por encima de ⁵⁶Fe, la fisión libera energía; por debajo, la fusión\n');
fprintf('• Núcleos doblemente mágicos: ⁴He, ¹⁶O, ⁴⁰Ca, ⁴⁸Ca, ²⁰⁸Pb\n');
fprintf('• Isótopos fisibles: ²³⁵U, ²³⁹Pu\n');
fprintf('• El cociente N/Z aumenta con A para mantener estabilidad en núcleos pesados\n');
fprintf('• Números mágicos (Z o N): 2, 8, 20, 28, 50, 82, 126\n\n');

fprintf('═════════════════════════════════════════════════════════════════════════\n');
fprintf('Nota: Los valores calculados son aproximaciones teóricas basadas en la\n');
fprintf('      fórmula semiempírica de masa. Para valores experimentales exactos,\n');
fprintf('      consultar la base de datos NUBASE o tablas de masas atómicas.\n');
fprintf('═════════════════════════════════════════════════════════════════════════\n\n');
