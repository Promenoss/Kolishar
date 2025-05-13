% filepath: c:\Users\piogw\Documents\GitHub\Kolishar\OporRos.m
clear; clc;
% Dane dla temperatury rosnącej
T_C_up = [22.0, 25.0, 30.0, 35.0, 40.0, 45.0, 50.0, 55.0, 60.0, 65.0, 70.0, 75.0, 80.0, 85.0, 90.0, 95.0];
T_K_up = T_C_up + 273.15;
R1_up = [170, 152, 126, 107, 90, 77, 66, 57, 49, 42, 36, 31, 26, 23, 18, 15];
R2_up = [224, 226, 229, 233, 237, 241, 244, 248, 252, 256, 260, 264, 268, 272, 277, 282];
R3_up = [619, 619, 619, 619, 619, 619, 619, 619, 619, 619, 619, 619, 619, 619, 618, 618];

% Dane dla temperatury spadającej
T_C_down = [95.0, 90.0, 85.0, 80.0, 75.0, 70.0, 65.0, 60.0, 55.0, 50.0, 45.0, 40.0, 35.0, 30.0, 25.0, 22.0];
T_K_down = T_C_down + 273.15;
R1_down = [15, 18, 23, 26, 31, 36, 42, 49, 57, 66, 77, 90, 107, 126, 152, 170];
R2_down = [282, 277, 272, 268, 264, 260, 256, 252, 248, 244, 241, 237, 233, 229, 226, 224];
R3_down = [618, 618, 619, 619, 619, 619, 619, 619, 619, 619, 619, 619, 619, 619, 619, 619];

% Przekształcenia danych
log_R1_up = log(R1_up)
log_R1_down = log(R1_down);
inv_T_up = 1 ./ T_K_up
inv_T_down = 1 ./ T_K_down;

% Niepewności
u_R = 1; % Niepewność oporu
u_T = 1; % Niepewność temperatury
u_log_R1_up = (1 ./ R1_up) * u_R;
u_log_R1_down = (1 ./ R1_down) * u_R;
u_inv_T_up = (1 ./ T_K_up.^2) * u_T;
u_inv_T_down = (1 ./ T_K_down.^2) * u_T;

% Funkcja do obliczania regresji i wyświetlania wyników
function p = calculate_regression(x, y, label)
    p = polyfit(x, y, 1);
    disp([label, ': a = ', num2str(p(1)), ', b = ', num2str(p(2))]);
end

% Funkcja do rysowania wykresów z regresją i niepewnościami
function plot_with_errorbars(x, y, x_err, y_err, p, x_label, y_label, title_text, legend_labels, color)
    errorbar(x, y, y_err, y_err, x_err, x_err, 'o', 'MarkerFaceColor', color, 'DisplayName', legend_labels{1});
    hold on;
    plot(x, polyval(p, x), '--', 'Color', color, 'DisplayName', legend_labels{2});
    xlabel(x_label);
    ylabel(y_label);
    title(title_text);
    legend("Location", "northwest");
    grid on;
end

% Obliczenie regresji
p_R2_up = calculate_regression(T_C_up, R2_up, 'R2 (rosnąca)');
p_R2_down = calculate_regression(T_C_down, R2_down, 'R2 (spadająca)');
p_R3_up = calculate_regression(T_C_up, R3_up, 'R3 (rosnąca)');
p_R3_down = calculate_regression(T_C_down, R3_down, 'R3 (spadająca)');
p_log_R1_up = calculate_regression(inv_T_up, log_R1_up, 'log(R1) (rosnąca)');
p_log_R1_down = calculate_regression(inv_T_down, log_R1_down, 'log(R1) (spadająca)');

% Wykresy log(R1)
figure;
plot_with_errorbars(inv_T_up, log_R1_up, u_inv_T_up, u_log_R1_up, ...
    p_log_R1_up, '1/T [1/K]', 'log(R1)', 'Zależność log(R1) od 1/T', ...
    {'log(R1) (rosnąca)', 'Regresja log(R1) (rosnąca)'}, 'b');
plot_with_errorbars(inv_T_down, log_R1_down, u_inv_T_down, u_log_R1_down, ...
    p_log_R1_down, '1/T [1/K]', 'log(R1)', 'Zależność log(R1) od 1/T', ...
    {'log(R1) (spadająca)', 'Regresja log(R1) (spadająca)'}, 'r');

% Wykresy R2
figure;
plot_with_errorbars(T_C_up, R2_up, ones(size(T_C_up)) * u_T, ones(size(R2_up)) * u_R, ...
    p_R2_up, 'Temperatura [°C]', 'Opór [Ω]', 'Zależność oporu R2 od temperatury [°C]', ...
    {'R2 [Ω] (rosnąca)', 'Regresja R2 (rosnąca)'}, 'b');
plot_with_errorbars(T_C_down, R2_down, ones(size(T_C_down)) * u_T, ones(size(R2_down)) * u_R, ...
    p_R2_down, 'Temperatura [°C]', 'Opór [Ω]', 'Zależność oporu R2 od temperatury [°C]', ...
    {'R2 [Ω] (spadająca)', 'Regresja R2 (spadająca)'}, 'r');

% Wykresy R3
figure;
plot_with_errorbars(T_C_up, R3_up, ones(size(T_C_up)) * u_T, ones(size(R3_up)) * u_R, ...
    p_R3_up, 'Temperatura [°C]', 'Opór [Ω]', 'Zależność oporu R3 od temperatury [°C]', ...
    {'R3 [Ω] (rosnąca)', 'Regresja R3 (rosnąca)'}, 'g');
plot_with_errorbars(T_C_down, R3_down, ones(size(T_C_down)) * u_T, ones(size(R3_down)) * u_R, ...
    p_R3_down, 'Temperatura [°C]', 'Opór [Ω]', 'Zależność oporu R3 od temperatury [°C]', ...
    {'R3 [Ω] (spadająca)', 'Regresja R3 (spadająca)'}, 'm');
ylim([610, 630]); % Dostosowanie zakresu osi Y