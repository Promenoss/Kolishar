% filepath: c:\Users\piogw\Documents\GitHub\Kolishar\OporRos.m
clear; clc; close all;
% Dane wejściowe
x = T_C_up; % Temperatura w °C (rosnąca)
y = R1_up;  % Opór R1 (rosnący)
n = length(x);

% Obliczenia sum
sum_x = sum(x);
sum_y = sum(y);
sum_xy = sum(x .* y);
sum_x2 = sum(x .^ 2);

% Obliczenie współczynników a i b
a = (n * sum_xy - sum_x * sum_y) / (n * sum_x2 - sum_x^2);
b = (sum_y - a * sum_x) / n;

% Obliczenie reszt i odchylenia standardowego s_y
y_pred = a * x + b; % Przewidywane wartości y
residuals = y - y_pred; % Reszty
s_y = sqrt(sum(residuals .^ 2) / (n - 2)); % Odchylenie standardowe reszt

% Obliczenie niepewności współczynnika a
u_a = s_y * sqrt(n / (n * sum_x2 - sum_x^2));

% Wyświetlenie wyników
disp(['Współczynnik kierunkowy a = ', num2str(a)]);
disp(['Niepewność u(a) = ', num2str(u_a)]);