% filepath: c:\Users\piogw\Documents\GitHub\Kolishar\kuladuza.m
clear; clc; close all;

% Dane
D = [69.08, 74.58] / 1000; % Średnia [m] (przekształcenie z mm na m)
logD = log10(D); % log(D)
Ep = [4.67937, 6.23916]; % Energia [J]
logEp = log10(Ep); % log(Ep)

% Wykres 1: Oryginalny wykres
figure;
plot(logEp, logD, '-o', 'LineWidth', 1.5);
grid on;
xlabel('log(Ep)');
ylabel('log(D)');
title('Wykres log(D) = f(log(Ep)) dla kulki dużej');

% Obliczenie współczynnika kierunkowego prostej regresji
coefficients = polyfit(logEp, logD, 1); % Dopasowanie prostej (1 oznacza liniową)
slope = coefficients(1); % Współczynnik kierunkowy
intercept = coefficients(2); % Wyraz wolny

% Wyświetlenie wyników
disp(['Współczynnik kierunkowy (slope): ', num2str(slope)]);
disp(['Wyraz wolny (intercept): ', num2str(intercept)]);

% Dodanie linii regresji do wykresu
hold on;
regression_line = polyval(coefficients, logEp); % Obliczenie wartości linii regresji
plot(logEp, regression_line, '--r', 'LineWidth', 1.5); % Dodanie linii regresji
legend('Dane', 'Linia regresji', 'Location', 'best');

disp(['Odwrotność współczynnika kierunkowego: ', num2str(1/slope)]); % Odwrotność współczynnika kierunkowego

% Wykres 2: Przedłużone osie
figure;
hold on;
% Przedłużenie zakresu osi, aby dotrzeć do punktu Y = 3.079
extended_logD = linspace(min(logD), 3.079, 100); % Przedłużenie log(D) do 3.079
extended_logEp = (extended_logD - intercept) / slope; % Obliczenie odpowiadających log(Ep)

% Rysowanie danych i linii regresji
plot(logEp, logD, 'o', 'LineWidth', 1.5); % Oryginalne punkty
plot(extended_logEp, extended_logD, '--r', 'LineWidth', 1.5); % Przedłużona linia regresji

% Zaznaczenie punktu na prostej regresji dla Y = 3.079
logD_point = 3.079; % Wartość na osi Y
logEp_point = (logD_point - intercept) / slope; % Obliczenie log(Ep) na podstawie prostej regresji
Ep_point = 10^logEp_point; % Obliczenie Ep
plot(logEp_point, logD_point, 'xk', 'MarkerSize', 10, 'LineWidth', 2); % Zaznaczenie punktu
text(logEp_point, logD_point, sprintf('  (%.3f, %.3f)', logEp_point, logD_point), 'FontSize', 10);

% Wyświetlenie wartości punktu w konsoli
disp(['Punkt na prostej regresji: log(Ep) = ', num2str(logEp_point), ', log(D) = ', num2str(logD_point)]);
disp(['Ep = ', num2str(Ep_point), ' J']);

% Ustawienia wykresu
grid on;
xlabel('log(Ep)');
ylabel('log(D)');
title('Przedłużony wykres log(D) = f(log(Ep)) z zaznaczonym punktem dla Y = 3.079');
legend('Dane', 'Linia regresji', 'Punkt na prostej (Y = 3.079)', 'Location', 'best');
hold off;

M_meteor = 3e8; % [kg]
v_meteor = 12000; % [m/s]

Ek_meteor = 0.5 * M_meteor * v_meteor^2; % Energia kinetyczna meteoru [J]
disp(['Energia kinetyczna meteoru: ', num2str(Ek_meteor), ' J']);