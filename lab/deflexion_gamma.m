
clear; clc; close all;
% --- PARTE 1: Curva Plateau ---
V = [450, 475, 500, 525, 550, 575, 600]; % Voltajes (V)
% Matriz de cuentas (cada fila un voltaje, cada columna una de las 6 medidas)
C_P1 = [ 0, 0, 0, 0, 0, 0;  % Rellenar con tus datos
         0, 0, 0, 0, 0, 0;
         0, 0, 0, 0, 0, 0;
         0, 0, 0, 0, 0, 0;
         0, 0, 0, 0, 0, 0;
         0, 0, 0, 0, 0, 0;
         0, 0, 0, 0, 0, 0 ]; 
t_P1 = 10; % Tiempo en segundos

% --- PARTE 2: Fondo y Poisson ---
C_P2 = zeros(1, 80); % Introduce aquí tus 80 medidas de fondo
t_P2 = 25; % Tiempo en segundos

% --- PARTE 3: Espectrómetro ---
theta_deg = 40:5:140; 
C_P3 = zeros(1, length(theta_deg)); % Cuentas por ángulo
t_P3 = 80; % Tiempo en segundos
C_fondo_P3 = 0; % Cuentas de fondo totales
t_fondo_P3 = 5 * t_P3;

% Parámetros físicos
B = 0.4;        % Campo magnético (Tesla)
R = 0.016;      % Radio imanes (m)
me = 0.511;     % Masa electrón (MeV/c^2)
sigma_theta = 2.5; % Error instrumental ángulo (grados)


% --- PARTE 1: PLATEAU ---
n_c_matriz = C_P1 ./ (t_P1 / 60); % cuentas/min
n_c_media = mean(n_c_matriz, 2);
sigma_nc = std(n_c_matriz, 0, 2) ./ sqrt(size(n_c_matriz, 2));

% --- PARTE 2: POISSON ---
media_fondo = mean(C_P2);
sigma_media_fondo = std(C_P2) / sqrt(length(C_P2));

% --- PARTE 3: ESPECTRO ---
r_bruto = C_P3 / (t_P3/60);
sigma_r_bruto = sqrt(C_P3) / (t_P3/60);
r_f = C_fondo_P3 / (t_fondo_P3/60);
sigma_rf = sqrt(C_fondo_P3) / (t_fondo_P3/60);

n_theta = r_bruto - r_f;
sigma_n_theta = sqrt(sigma_r_bruto.^2 + sigma_rf^2);

% Calibración Energía y Jacobiano
theta_rad = deg2rad(theta_deg);
pc = (300 * B * R) ./ tan(theta_rad / 2);
Ec = sqrt(pc.^2 + me^2) - me;

% Jacobiano |dE/d_theta|
Jac = (pc.^2 ./ (Ec + me)) .* (1 ./ abs(sin(theta_rad)));
n_E = n_theta ./ Jac;
sigma_n_E = sigma_n_theta ./ Jac;
sigma_Ec = Jac .* deg2rad(sigma_theta);


fprintf('--- RESULTADOS PARTE 1: PLATEAU ---\n');
for i = 1:length(V)
    [v_f, e_f] = aplicar_criterio_guia(n_c_media(i), sigma_nc(i));
    fprintf('V = %d V: n_c = (%s ± %s) min^-1\n', V(i), v_f, e_f);
end

fprintf('\n--- RESULTADOS PARTE 2: FONDO ---\n');
[bf, ef] = aplicar_criterio_guia(media_fondo, sigma_media_fondo);
fprintf('Media Fondo: %s ± %s cuentas\n', bf, ef);


% Gráfica Poisson
figure('Color', 'w');
h = histogram(C_P2, 'Normalization', 'count', 'FaceColor', [.8 .8 .8]);
hold on;
x_pois = min(C_P2):max(C_P2);
f_teo = length(C_P2) * poisspdf(x_pois, media_fondo);
errorbar(x_pois, f_teo, sqrt(f_teo), 'ro-', 'LineWidth', 1.5);
xlabel('Número de cuentas'); ylabel('Frecuencia');
title('Estadística de Poisson (Fondo)');
grid on;

% Gráfica Espectro de Energía
figure('Color', 'w');
errorbar(Ec, n_E, sigma_n_E, sigma_n_E, sigma_Ec, sigma_Ec, 'bo');
xlabel('E_c (MeV)'); ylabel('n(E_c) (min^{-1} MeV^{-1})');
title('Espectro Energético de Partículas \beta');
grid on;


%% FUNCIÓN AUXILIAR: CRITERIO DE CIFRAS SIGNIFICATIVAS

function [val_str, err_str] = aplicar_criterio_guia(val, err)
    if err == 0 || isnan(err), val_str = num2str(val); err_str = '0'; return; end
    
    % Primer dígito significativo del error
    exp_err = floor(log10(err));
    primer_digito = floor(err / 10^exp_err);
    segundo_digito = floor((err / 10^exp_err - primer_digito) * 10);
    
    % Criterio: 2 cifras si es 1 o (2 y <5), si no, 1 cifra
    if (primer_digito == 1) || (primer_digito == 2 && segundo_digito < 5)
        n_cifras = 2;
    else
        n_cifras = 1;
    end
    
    decimales = -(exp_err - n_cifras + 1);
    
    if decimales <= 0
        fmt = '%.0f';
        err_red = round(err, decimales);
        val_red = round(val, decimales);
    else
        fmt = sprintf('%%.%df', decimales);
        err_red = round(err, decimales);
        val_red = round(val, decimales);
    end
    
    val_str = sprintf(fmt, val_red);
    err_str = sprintf(fmt, err_red);
end
