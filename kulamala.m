% filepath: c:\Users\piogw\Documents\GitHub\Kolishar\kulamala.m
clear; clc; close all;

% Dane
D = [29.03, 37.23, 41.42, 44.22, 47.83] / 1000; % Średnia [m] (przekształcenie z mm na m)
logD = log10(D); % log(D)
Ep = [0.0981, 0.1962, 0.3924, 0.5886, 0.7848]; % Energia [J]
logEp = log10(Ep); % log(Ep)

% Wykres
figure;
plot(logEp, logD, '-o', 'LineWidth', 1.5);
grid on;
xlabel('log(Ep)');
ylabel('log(D)');
title('Wykres log(D) = f(log(Ep)) dla kulki małej');

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