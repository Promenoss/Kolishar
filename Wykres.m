% filepath: c:\Users\piogw\Documents\GitHub\Kolishar\test.m
clear; clc; close all;

% Dane
m = [0, 1, 2, 3, 4, 5, 6, 6.5]; % Obciążenie dodatkowe [kg]
g = 9.81; % Przyspieszenie ziemskie [m/s^2]
F = m * g; % Siła obciążenia [N]

% Przyrosty długości drutu (z tabeli)
delta_l_1 = [NaN, 9.70E-05, 2.91E-04, 1.94E-04, 4.85E-04, 6.79E-04, 4.85E-04, 6.79E-04]; % [m]
delta_l_2 = [NaN, 0, 0, 1.94E-04, 2.91E-04, 4.85E-04, 5.82E-04, 6.79E-04]; % [m]

% Wykresy
figure;
hold on;
plot(F, delta_l_1, 'o', 'LineWidth', 1.5, 'DisplayName', '\Delta l (Pomiar 1)'); % Tylko punkty
plot(F, delta_l_2, 's', 'LineWidth', 1.5, 'DisplayName', '\Delta l (Pomiar 2)'); % Tylko punkty
grid on;
xlabel('Siła obciążenia F [N]');
ylabel('Przyrost długości \Delta l [m]');
title('Zależność \Delta l = f(F)');
legend('Location', 'best');
hold off;