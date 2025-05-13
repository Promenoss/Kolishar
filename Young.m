clear; clc; close all;

% Dane
d = 0.82e-3; % Średnica drutu [m] (średnia wartość z tabeli)
L0 = 0.95; % Początkowa długość drutu [m]
A = pi * (d / 2)^2; % Pole przekroju poprzecznego drutu [m^2]

% Niepewności pomiarowe
u_d = 0.01e-3; % Niepewność średnicy drutu [m]
u_L0 = 0.01; % Niepewność początkowej długości drutu [m]
u_delta_l = 0.01e-4; % Niepewność przyrostu długości drutu [m]
u_m = 0.01; % Niepewność masy [kg]

% Siła obciążenia [N]
m = [0, 1, 2, 3, 4, 5, 6, 6.5]; % Obciążenie dodatkowe [kg]
g = 9.81; % Przyspieszenie ziemskie [m/s^2]
F = m * g; % Siła obciążenia [N]
u_F = g * u_m; % Niepewność siły obciążenia [N]

% Przyrost długości drutu (z tabeli)
delta_l_1 = [NaN, 9.70E-05, 2.91E-04, 1.94E-04, 4.85E-04, 6.79E-04, 4.85E-04, 6.79E-04]; % [m]
delta_l_2 = [NaN, 0, 0, 1.94E-04, 2.91E-04, 4.85E-04, 5.82E-04, 6.79E-04]; % [m]

% Niepewność pola przekroju poprzecznego
u_A = 2 * pi * (d / 2) * u_d; % Niepewność pola przekroju [m^2]

% Obliczenie modułu Younga dla pomiaru 1
E_1 = (F .* L0) ./ (A .* delta_l_1); % Moduł Younga [Pa]
E_1_GPa = E_1 / 1e9; % Moduł Younga w GPa

% Obliczenie niepewności modułu Younga dla pomiaru 1
u_E_1 = E_1 .* sqrt((u_F ./ F).^2 + (u_L0 ./ L0).^2 + (u_A ./ A).^2 + (u_delta_l ./ delta_l_1).^2);
u_E_1_GPa = u_E_1 / 1e9; % Niepewność modułu Younga w GPa

% Obliczenie modułu Younga dla pomiaru 2
E_2 = (F .* L0) ./ (A .* delta_l_2); % Moduł Younga [Pa]
E_2_GPa = E_2 / 1e9; % Moduł Younga w GPa

% Obliczenie niepewności modułu Younga dla pomiaru 2
u_E_2 = E_2 .* sqrt((u_F ./ F).^2 + (u_L0 ./ L0).^2 + (u_A ./ A).^2 + (u_delta_l ./ delta_l_2).^2);
u_E_2_GPa = u_E_2 / 1e9; % Niepewność modułu Younga w GPa

% Wyświetlenie wyników
disp('Moduł Younga dla pomiaru 1 [GPa] i niepewność:');
disp([E_1_GPa; u_E_1_GPa]);

disp('Moduł Younga dla pomiaru 2 [GPa] i niepewność:');
disp([E_2_GPa; u_E_2_GPa]);

% Filtrowanie danych, aby pominąć NaN i Inf
valid_indices_1 = isfinite(E_1_GPa) & isfinite(u_E_1_GPa); % Indeksy skończonych wartości dla pomiaru 1
valid_indices_2 = isfinite(E_2_GPa) & isfinite(u_E_2_GPa); % Indeksy skończonych wartości dla pomiaru 2

% Obliczenie średniego modułu Younga i niepewności
E_avg_GPa = mean([E_1_GPa(valid_indices_1), E_2_GPa(valid_indices_2)]); % Średni moduł Younga [GPa]
u_E_avg_GPa = sqrt(mean([u_E_1_GPa(valid_indices_1).^2, u_E_2_GPa(valid_indices_2).^2])); % Średnia niepewność [GPa]

% Wyświetlenie wyniku
disp(['Średni moduł Younga: ', num2str(E_avg_GPa), ' ± ', num2str(u_E_avg_GPa), ' GPa']);