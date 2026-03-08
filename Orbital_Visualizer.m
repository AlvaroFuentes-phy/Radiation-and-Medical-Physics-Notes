% This script computes the hydrogenic wave function and renders its 3D isosurface.

clear; clc; close all;

% --- 1. Quantum Numbers Selection ---
% Adjust these to visualize different atomic states
n = 3;      % Principal quantum number (Shell: K, L, M...)
l = 2;      % Azimuthal quantum number (Subshell: s, p, d, f)
m = 0;      % Magnetic quantum number (Orientation)

% --- 2. Grid Setup ---
% Spatial coordinates in Bohr radii (a0)
points = 100;
limit = n^2 + 4*l; % Dynamic grid size based on n
x = linspace(-limit, limit, points);
[X, Y, Z] = meshgrid(x, x, x);

% Transformation to Spherical Coordinates (Standard Physics Convention)
[phi, elev, r] = cart2sph(X, Y, Z);
theta = pi/2 - elev; % Convert elevation to polar angle theta

% --- 3. Wavefunction Calculation: psi(r, theta, phi) ---
% Radial Part (Simplified Laguerre-dependent decay)
R_nl = (2*r/n).^l .* exp(-r/n); 

% Angular Part (Associated Legendre Polynomials)
P_lm = legendre(l, cos(theta(:)));
if l ~= 0
    % Select the row corresponding to the absolute value of m
    P_lm = reshape(P_lm(abs(m)+1, :), size(theta));
else
    P_lm = reshape(P_lm, size(theta));
end

% Real part of the Spherical Harmonic
Y_lm = P_lm .* cos(m * phi);

% Total Wavefunction
Psi = R_nl .* Y_lm;

% --- 4. 3D Visualization (Isosurface) ---
figure('Color', 'w', 'Name', ['Orbital n=', num2str(n), ' l=', num2str(l)]);
hold on;

% Threshold for the isosurface (10% of maximum amplitude)
iso_val = max(abs(Psi(:))) * 0.1;

% Render Positive Phase (Red)
p1 = patch(isosurface(X, Y, Z, Psi, iso_val), ...
    'FaceColor', [0.85 0.33 0.1], 'EdgeColor', 'none', 'FaceAlpha', 0.8);

% Render Negative Phase (Blue)
p2 = patch(isosurface(X, Y, Z, Psi, -iso_val), ...
    'FaceColor', [0 0.45 0.74], 'EdgeColor', 'none', 'FaceAlpha', 0.8);

% Plot Aesthetics
camlight; lighting gouraud; 
axis equal; grid on; view(3);
xlabel('x/a_0'); ylabel('y/a_0'); zlabel('z/a_0');
title(['\Psi_{', num2str(n), num2str(l), num2str(m), '} Wavefunction Phase'], ...
      'Interpreter', 'latex', 'FontSize', 14);
legend([p1, p2], {'Phase (+)', 'Phase (-)'}, 'Location', 'northeast')
