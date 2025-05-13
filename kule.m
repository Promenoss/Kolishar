% filepath: c:\Users\piogw\Documents\GitHub\Kolishar\kule.m
clear; clc; close all;

% Dane dla kulki małej
D_mala = [29.03, 37.23, 41.42, 44.22, 47.83] / 1000; % Średnia [m]
logD_mala = log10(D_mala); % log(D)
Ep_mala = [0.0981, 0.1962, 0.3924, 0.5886, 0.7848]; % Energia [J]
logEp_mala = log10(Ep_mala); % log(Ep)

% Dane dla kulki średniej
D_srednia = [45.22, 51.88, 59.62, 61.33] / 1000; % Średnia [m]
logD_srednia = log10(D_srednia); % log(D)
Ep_srednia = [0.6867, 1.3734, 2.0601, 2.7468]; % Energia [J]
logEp_srednia = log10(Ep_srednia); % log(Ep)

% Dane dla kulki dużej
D_duza = [69.08, 74.58] / 1000; % Średnia [m]
logD_duza = log10(D_duza); % log(D)
Ep_duza = [4.67937, 6.23916]; % Energia [J]
logEp_duza = log10(Ep_duza); % log(Ep)

% Wykres 1: Połączone dane z prostą regresji
figure;
hold on;
plot(logEp_mala, logD_mala, '-o', 'LineWidth', 1.5, 'DisplayName', 'Kulki małe');
plot(logEp_srednia, logD_srednia, '-s', 'LineWidth', 1.5, 'DisplayName', 'Kulki średnie');
plot(logEp_duza, logD_duza, '-d', 'LineWidth', 1.5, 'DisplayName', 'Kulki duże');

% Połączenie danych
logEp_all = [logEp_mala, logEp_srednia, logEp_duza]; % Połączenie log(Ep)
logD_all = [logD_mala, logD_srednia, logD_duza]; % Połączenie log(D)

% Obliczenie współczynnika kierunkowego prostej regresji
coefficients_all = polyfit(logEp_all, logD_all, 1); % Dopasowanie prostej regresji
slope_all = coefficients_all(1); % Współczynnik kierunkowy
intercept_all = coefficients_all(2); % Wyraz wolny

% Dodanie prostej regresji
logEp_range = linspace(min(logEp_all), max(logEp_all), 100); % Zakres log(Ep) dla prostej
logD_fit = polyval(coefficients_all, logEp_range); % Obliczenie wartości log(D) na podstawie regresji
plot(logEp_range, logD_fit, '--b', 'LineWidth', 2.5, 'DisplayName', 'Linia regresji (połączone dane)');

grid on;
xlabel('log(Ep)');
ylabel('log(D)');
title('Wykres log(D) = f(log(Ep)) dla wszystkich pomiarów z prostą regresji');
legend('Location', 'best');
hold off;

% Wyświetlenie wyników
disp(['Współczynnik kierunkowy dla połączonych danych: ', num2str(slope_all)]);
disp(['Wyraz wolny dla połączonych danych: ', num2str(intercept_all)]);
disp(['Odwrotność współczynnika kierunkowego dla połączonych danych: ', num2str(1/slope_all)]); % Odwrotność współczynnika kierunkowego

% Wykres 2: Rozszerzone osie z wszystkimi punktami
coefficients = polyfit(logEp_duza, logD_duza, 1); % Dopasowanie prostej regresji dla kulki dużej
slope = coefficients(1); % Współczynnik kierunkowy
intercept = coefficients(2); % Wyraz wolny

figure;
hold on;
% Przedłużenie zakresu osi, aby dotrzeć do punktu Y = 3.079
extended_logD = linspace(min(logD_duza), 3.079, 100); % Przedłużenie log(D) do 3.079
extended_logEp = (extended_logD - intercept) / slope; % Obliczenie odpowiadających log(Ep)

% Rysowanie wszystkich punktów
plot(logEp_mala, logD_mala, 'o', 'LineWidth', 1.5, 'DisplayName', 'Kulki małe');
plot(logEp_srednia, logD_srednia, 's', 'LineWidth', 1.5, 'DisplayName', 'Kulki średnie');
plot(logEp_duza, logD_duza, 'd', 'LineWidth', 1.5, 'DisplayName', 'Kulki duże');

% Rysowanie linii regresji
plot(extended_logEp, extended_logD, '--g', 'LineWidth', 2.5, 'DisplayName', 'Linia regresji');

% Zaznaczenie punktu na prostej regresji dla Y = 3.079
logD_point = 3.079; % Wartość na osi Y
logEp_point = (logD_point - intercept) / slope; % Obliczenie log(Ep) na podstawie prostej regresji
Ep_point = 10^logEp_point; % Obliczenie Ep
plot(logEp_point, logD_point, 'xk', 'MarkerSize', 10, 'LineWidth', 2, 'DisplayName', 'Punkt (Y = 3.079)');
text(logEp_point, logD_point, sprintf('  (%.3f, %.3f)', logEp_point, logD_point), 'FontSize', 10);

% Wyświetlenie wartości punktu w konsoli
disp(['Punkt na prostej regresji: log(Ep) = ', num2str(logEp_point), ', log(D) = ', num2str(logD_point)]);
disp(['Ep = ', num2str(Ep_point), ' J']);

grid on;
xlabel('log(Ep)');
ylabel('log(D)');
title('Rozszerzony wykres log(D) = f(log(Ep)) z wszystkimi punktami');
legend('Location', 'best');
hold off;