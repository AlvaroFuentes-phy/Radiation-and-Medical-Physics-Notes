% =========================================================================
% Práctica II: Detector Geiger-Müller (Eficiencia y Atenuación)
% Análisis con cálculo riguroso de incertidumbres y cifras significativas
% =========================================================================
clear; clc; close all;

%% 1. DATOS EXPERIMENTALES (Introduce aquí tus medidas)
% -------------------------------------------------------------------------

% --- Actividad de las fuentes (Ajustar al día de la práctica) ---
A_Sr90 = 37000; % Actividad de Sr-90 en Bq (desintegraciones/s)
A_Co60 = 37000; % Actividad de Co-60 en Bq

% --- Fondo de radiación ---
C_fondo = 0;    % Cuentas totales del fondo
t_fondo = 100;  % Tiempo de medida del fondo (s)

% --- PARTE 1: Eficiencia vs Distancia (Fuente: Sr-90) ---
distancias = [1, 2, 3, 4, 5]; % Distancias en cm
C_efi = zeros(1, length(distancias)); % Cuentas medidas para cada distancia
t_efi = zeros(1, length(distancias)); % Tiempo de medida para cada distancia (s)

% --- PARTE 2: Atenuación Másica ---
% 2.1 Sr-90 (Beta) en Aluminio (Al)
x_m_Al_beta = [0, 0.1, 0.2, 0.3, 0.4]; % Espesores másicos de Al (g/cm^2)
C_Al_beta = zeros(1, length(x_m_Al_beta)); % Cuentas
t_Al_beta = zeros(1, length(x_m_Al_beta)); % Tiempos (s)

% 2.2 Sr-90 (Beta) en Plomo (Pb)
x_m_Pb_beta = [0, 0.1, 0.2, 0.3, 0.4]; % Espesores másicos de Pb (g/cm^2)
C_Pb_beta = zeros(1, length(x_m_Pb_beta)); 
t_Pb_beta = zeros(1, length(x_m_Pb_beta)); 

% 2.3 Co-60 (Gamma) en Aluminio (Al)
x_m_Al_gamma = [0, 0.5, 1.0, 1.5, 2.0]; % Espesores másicos de Al (g/cm^2)
C_Al_gamma = zeros(1, length(x_m_Al_gamma)); 
t_Al_gamma = zeros(1, length(x_m_Al_gamma)); 

% 2.4 Co-60 (Gamma) en Plomo (Pb)
x_m_Pb_gamma = [0, 0.5, 1.0, 1.5, 2.0]; % Espesores másicos de Pb (g/cm^2)
C_Pb_gamma = zeros(1, length(x_m_Pb_gamma)); 
t_Pb_gamma = zeros(1, length(x_m_Pb_gamma)); 


%% 2. PROCESAMIENTO DE DATOS
% -------------------------------------------------------------------------
% Tasa de fondo y su error
r_fondo = C_fondo / t_fondo; 
err_r_fondo = sqrt(C_fondo) / t_fondo;

% --- PARTE 1: EFICIENCIA ABSOLUTA ---
% Calculamos la tasa neta: r_neta = (C/t) - r_fondo
r_efi = C_efi ./ t_efi;
err_r_efi = sqrt(C_efi) ./ t_efi;

r_neta_efi = r_efi - r_fondo;
err_rneta_efi = sqrt(err_r_efi.^2 + err_r_fondo.^2);

% Eficiencia absoluta = r_neta (s^-1) / Actividad (Bq)
eficiencia = r_neta_efi / A_Sr90;
err_eficiencia = err_rneta_efi / A_Sr90;

% --- PARTE 2: ATENUACIÓN MÁSICA (Función genérica al final del script) ---
[mu_Al_beta, err_mu_Al_beta, R_Al_beta, eR_Al_beta] = calc_atenuacion(C_Al_beta, t_Al_beta, r_fondo, err_r_fondo, x_m_Al_beta);
[mu_Pb_beta, err_mu_Pb_beta, R_Pb_beta, eR_Pb_beta] = calc_atenuacion(C_Pb_beta, t_Pb_beta, r_fondo, err_r_fondo, x_m_Pb_beta);
[mu_Al_gamma, err_mu_Al_gamma, R_Al_gamma, eR_Al_gamma] = calc_atenuacion(C_Al_gamma, t_Al_gamma, r_fondo, err_r_fondo, x_m_Al_gamma);
[mu_Pb_gamma, err_mu_Pb_gamma, R_Pb_gamma, eR_Pb_gamma] = calc_atenuacion(C_Pb_gamma, t_Pb_gamma, r_fondo, err_r_fondo, x_m_Pb_gamma);


%% 3. SALIDA DE RESULTADOS EN CONSOLA
% -------------------------------------------------------------------------
fprintf('====================================================\n');
fprintf('--- PARTE 1: EFICIENCIA DEL DETECTOR ---\n');
fprintf('Distancia (cm) \t Eficiencia Absoluta\n');
for i = 1:length(distancias)
    [v_str, e_str] = aplicar_criterio_guia(eficiencia(i), err_eficiencia(i));
    fprintf('  %.1f \t\t %s ± %s\n', distancias(i), v_str, e_str);
end

fprintf('\n====================================================\n');
fprintf('--- PARTE 2: COEFICIENTES DE ATENUACIÓN MÁSICA (cm^2/g) ---\n');
[v1, e1] = aplicar_criterio_guia(mu_Al_beta, err_mu_Al_beta);
[v2, e2] = aplicar_criterio_guia(mu_Pb_beta, err_mu_Pb_beta);
[v3, e3] = aplicar_criterio_guia(mu_Al_gamma, err_mu_Al_gamma);
[v4, e4] = aplicar_criterio_guia(mu_Pb_gamma, err_mu_Pb_gamma);

fprintf('Radiación Beta (Sr-90) en Aluminio: %s ± %s\n', v1, e1);
fprintf('Radiación Beta (Sr-90) en Plomo:    %s ± %s\n', v2, e2);
fprintf('Radiación Gamma (Co-60) en Aluminio: %s ± %s\n', v3, e3);
fprintf('Radiación Gamma (Co-60) en Plomo:    %s ± %s\n', v4, e4);
fprintf('(NOTA: Ajustes realizados ignorando puntos con tasa neta <= 0)\n');

%% 4. REPRESENTACIÓN GRÁFICA
% -------------------------------------------------------------------------

% Figura 1: Eficiencia vs Distancia
figure('Name', 'Eficiencia vs Distancia', 'Color', 'w');
errorbar(distancias, eficiencia, err_eficiencia, 'ko-', 'LineWidth', 1.5, 'MarkerFaceColor', 'k');
title('Eficiencia absoluta en función de la distancia');
xlabel('Distancia / cm');
ylabel('Eficiencia \epsilon_{abs}');
grid on;

% Figura 2: Atenuación Beta (Escala Logarítmica)
figure('Name', 'Atenuación Beta', 'Color', 'w');
errorbar(x_m_Al_beta, R_Al_beta, eR_Al_beta, 'bo-', 'LineWidth', 1.2, 'MarkerFaceColor', 'b'); hold on;
errorbar(x_m_Pb_beta, R_Pb_beta, eR_Pb_beta, 'ro-', 'LineWidth', 1.2, 'MarkerFaceColor', 'r');
set(gca, 'YScale', 'log'); % Eje Y logarítmico para visualizar linealidad
title('Atenuación de radiación \beta^- (^{90}Sr)');
xlabel('Espesor másico (\rho x) / (g cm^{-2})');
ylabel('Tasa de cuentas neta / s^{-1}');
legend('Aluminio', 'Plomo');
grid on;

% Figura 3: Atenuación Gamma (Escala Logarítmica)
figure('Name', 'Atenuación Gamma', 'Color', 'w');
errorbar(x_m_Al_gamma, R_Al_gamma, eR_Al_gamma, 'bo-', 'LineWidth', 1.2, 'MarkerFaceColor', 'b'); hold on;
errorbar(x_m_Pb_gamma, R_Pb_gamma, eR_Pb_gamma, 'ro-', 'LineWidth', 1.2, 'MarkerFaceColor', 'r');
set(gca, 'YScale', 'log'); 
title('Atenuación de radiación \gamma (^{60}Co)');
xlabel('Espesor másico (\rho x) / (g cm^{-2})');
ylabel('Tasa de cuentas neta / s^{-1}');
legend('Aluminio', 'Plomo');
grid on;

%% ========================================================================
%% FUNCIONES AUXILIARES
%% ========================================================================

function [mu, err_mu, R_neta, err_R_neta] = calc_atenuacion(C, t, r_fondo, err_fondo, x)
    % Calcula la tasa neta y el ajuste lineal para el coeficiente másico
    r_bruta = C ./ t;
    err_bruta = sqrt(C) ./ t;
    
    R_neta = r_bruta - r_fondo;
    err_R_neta = sqrt(err_bruta.^2 + err_fondo.^2);
    
    % Filtramos valores <= 0 para poder aplicar el logaritmo
    idx = R_neta > 0;
    x_fit = x(idx);
    y_fit = log(R_neta(idx));
    
    if sum(idx) > 1
        % Propagación del error al logaritmo: error(ln(R)) = error(R) / R
        w = 1 ./ (err_R_neta(idx) ./ R_neta(idx)).^2; % Pesos para el ajuste
        
        % Ajuste lineal ponderado y = -mu * x + b
        [p, S] = polyfit(x_fit, y_fit, 1);
        mu = -p(1); % El coeficiente es la pendiente cambiada de signo
        
        % Extracción de la incertidumbre estadística del ajuste (dispersión)
        cov_matrix = (S.normr^2 / S.df) * inv(S.R) * inv(S.R)';
        err_mu = sqrt(cov_matrix(1,1));
    else
        mu = 0; err_mu = 0;
    end
end

function [val_str, err_str] = aplicar_criterio_guia(val, err)
    % Aplica el criterio de 1 o 2 cifras significativas
    if err == 0 || isnan(err), val_str = num2str(val); err_str = num2str(err); return; end
    
    exp_err = floor(log10(err));
    primer_digito = floor(err / 10^exp_err);
    segundo_digito = floor((err / 10^exp_err - primer_digito) * 10);
    
    if (primer_digito == 1) || (primer_digito == 2 && segundo_digito < 5)
        n_cifras = 2;
    else
        n_cifras = 1;
    end
    
    decimales = -(exp_err - n_cifras + 1);
    
    if decimales <= 0
        fmt = '%.0f';
    else
        fmt = sprintf('%%.%df', decimales);
    end
    
    val_str = sprintf(fmt, round(val, decimales));
    err_str = sprintf(fmt, round(err, decimales));
end
