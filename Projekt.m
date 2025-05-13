clear; clc; close all;

% Dane początkowe
m = randi([10, 1000000]);
g = 9.81; % Przyspieszenie ziemskie
rho = 1.225; % Gęstość powietrza [kg/m^3]
C = 0.5; % Współczynnik oporu powietrza
A = 0.5; % Powierzchnia czołowa [m^2]
v_in = randi([0, 1000]); % Prędkość wejścia w atmosferę
alpha = randi([90, 270]); % Kąt Y w stopniach
beta = randi([0, 360]); % Kąt X w stopniach
gamma = randi([0, 360]); % Kąt Z w stopniach

fprintf('Wylosowana masa meteorytu: %d kg\n', m);
fprintf('Wylosowane kąty: [%.2f, %.2f, %.2f] stopni\n', alpha, beta, gamma);

% Dane obliczeniowe
v_terminal = sqrt((2 * m * g) / (rho * C * A)); % Prędkość graniczna meteorytu

dydt = @(t, y) [
    y(2); % Pochodna wysokości Y (prędkość pionowa)
    -g - (rho * C * A * y(2)^2)/(2 * m) * (abs(y(2)) < v_terminal); % Przyspieszenie pionowe (uwzględnia prędkość graniczną)
    y(4); % Pochodna położenia X
    -(rho * C * A * y(4)^2)/(2 * m) * sign(y(4)); % Przyspieszenie poziome w pierwszym wymiarze
    y(6); % Pochodna położenia Y
    -(rho * C * A * y(6)^2)/(2 * m) * sign(y(6)); % Przyspieszenie poziome w drugim wymiarze
];

tspan = [0 500]; % Maksymalny zakres czasu
h0 = 200000; % Wysokość pierwotna
vy_in = v_in*cosd(alpha); % Prędkość y
vx_in = v_in*cosd(beta); % Prędkość x
vz_in = v_in*cosd(gamma); % Prędkość z
xz_in = randi([0 50000]); % Położenie względem płaszczyzn x i z

y0 = [h0; vy_in; xz_in; vx_in; xz_in; vz_in]; % Warunki początkowe [wysokość, prędkość pionowa, położenie 1D, prędkość 1D, położenie 2D, prędkość 2D]
fprintf('Warunki początkowe: [%.2f, %.2f, %.2f, %.2f, %.2f, %.2f]\n', y0(1), y0(2), y0(3), y0(4), y0(5), y0(6));

% Opcje solvera z warunkiem zatrzymania (zwiększenie częstotliwości dla bardziej poprawnych danych)
options = odeset('RelTol', 1e-6, 'AbsTol', 1e-6, 'Events', @(t, y) stopCondition(t, y));
[t, y] = ode45(dydt, tspan, y0, options);

% Znalezienie czasu uderzenia w ziemię
impact_index = find(y(:,1) <= 0, 1); % Znajdź pierwszy indeks, gdzie wysokość <= 0
if ~isempty(impact_index)
    fprintf('Czas do uderzenia w ziemię: %.2f sekund\n', t(impact_index));
    fprintf('Położenie względem płaszczyzny poziomej w momencie uderzenia: [%.2f, %.2f] m\n', y(impact_index, 3), y(impact_index, 5));
else
    fprintf('Meteoryt nie uderzył w ziemię w podanym zakresie czasu.\n');
end

a_rakieta = 70; % Przyspieszenie rakiety [m/s^2]

% Znalezienie punktu na trajektorii meteorytu, w który rakieta uderzy najszybciej
distances = sqrt(y(:,3).^2 + y(:,5).^2 + y(:,1).^2); % Odległości meteorytu od punktu (0, 0, 0)
t_rakieta_all = sqrt(2 * distances / a_rakieta); % Czas potrzebny rakiecie do osiągnięcia każdego punktu
time_differences = abs(t - t_rakieta_all); % Różnice czasowe między meteorytem a rakietą
[~, impact_index] = min(time_differences); % Znalezienie indeksu minimalnej różnicy czasowej

% Punkt docelowy rakiety (najbliższy punkt na trajektorii meteorytu)
target_position = [y(impact_index, 3), y(impact_index, 5), y(impact_index, 1)];
fprintf('\nPunkt docelowy rakiety: [%.2f, %.2f, %.2f] m\n', target_position);
distance = sqrt(target_position(1)^2 + target_position(2)^2 + target_position(3)^2); % Odległość do punktu docelowego
t_rakieta = sqrt(2 * distance / a_rakieta); % Czas do punktu docelowego rakiety


num_frames = 50; % Ilość klatek
% Interpolacja trajektorii meteorytu do tej samej liczby klatek co rakieta
t_interp = linspace(t(1), t(impact_index), num_frames); % Czas dla interpolacji meteorytu
y_interp = interp1(t(1:impact_index), y(1:impact_index, :), t_interp, 'linear'); % Interpolacja pozycji meteorytu

% Interpolacja trajektorii rakiety
t_rakieta_traj = linspace(0, t_rakieta, num_frames); % Czas dla trajektorii rakiety
s_rakieta = 0.5 * a_rakieta * t_rakieta_traj.^2; % Przemieszczenie rakiety

% Współrzędne rakiety w czasie
x_rakieta = (target_position(1) / distance) * s_rakieta; % Ruch w osi X
y_rakieta = (target_position(2) / distance) * s_rakieta; % Ruch w osi Y
z_rakieta = target_position(3) * (t_rakieta_traj / t_rakieta) .* (2 - (t_rakieta_traj / t_rakieta)); % Paraboliczny ruch w osi Z

dx = target_position(1); % Odległość w osi X
dy = target_position(2); % Odległość w osi Y
dz = target_position(3); % Wysokość w osi Z

distance_xy = sqrt(dx^2 + dy^2); % Odległość w płaszczyźnie XY
theta_xy = atan2d(dy, dx); % Kąt w stopniach w płaszczyźnie XY
theta_xz = atan2d(dz, distance_xy); % Kąt w stopniach w płaszczyźnie XZ

v_end = a_rakieta * t_rakieta; % Maksymalna prędkość rakiety (v = a * t)
v_max = 5000; % Maksymalna prędkość rakiety w powietrzu (przyjęta)

if v_end > v_max
    fprint('Rakieta nie może lecieć tak szybko!');
end

fprintf('\nKąt wystrzału rakiety w płaszczyźnie XY: %.2f stopni\n', theta_xy);
fprintf('Kąt wystrzału rakiety w płaszczyźnie XZ: %.2f stopni\n', theta_xz);
fprintf('Końcowa prędkość rakiety: %.2f m/s\n', v_end);

% Okno animacji
fig = figure;
plot3(y(:,3), y(:,5), y(:,1), 'b-', 'LineWidth', 1.5); % Trajektoria meteorytu
hold on;
plot3(x_rakieta, y_rakieta, z_rakieta, 'r-', 'LineWidth', 1.5); % Trajektoria rakiety
scatter3(target_position(1), target_position(2), target_position(3), 75, 'g', 'filled'); % Punkt zderzenia
xlabel('Położenie x [m]');
ylabel('Położenie y [m]');
zlabel('Wysokość z [m]');
title('Trajektoria meteorytu i rakiety');
legend('Trajektoria meteorytu', 'Trajektoria rakiety', 'Punkt zderzenia');
grid on;

% Obiekty animacji
h_meteoryt = scatter3(y_interp(1,3), y_interp(1,5), y_interp(1,1), 75, 'b', 'filled');
h_rakieta = scatter3(0, 0, 0, 75, 'r', 'filled');

while isvalid(fig)
    for i = 1:num_frames
        if ~isvalid(fig)
            break; % Przerwij pętlę, jeśli okno zostało zamknięte
        end
        
        % Aktualizacja pozycji rakiety
        set(h_rakieta, 'XData', x_rakieta(i), 'YData', y_rakieta(i), 'ZData', z_rakieta(i));
        
        % Aktualizacja pozycji meteorytu
        set(h_meteoryt, 'XData', y_interp(i,3), 'YData', y_interp(i,5), 'ZData', y_interp(i,1));
        
        pause(0.1);
    end
end

% Wyświetlenie komunikatu o zderzeniu po zamknięciu okna
if ~isvalid(fig)
    disp('Rakieta dotarła do punktu zderzenia z meteorytem.');
end

function [value, isterminal, direction] = stopCondition(~, y)
    value = y(1);
    isterminal = 1;
    direction = -1;
end