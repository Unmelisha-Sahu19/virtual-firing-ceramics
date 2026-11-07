%% VIRTUAL FIRING OF CERAMIC RAW MATERIALS
% Data-driven, simulation-only study of kaolinite dehydroxylation.
% All inputs come from the CSV files in /data (taken from published sources).
% Run this file in MATLAB (R2018b or newer). No toolboxes required.

clc; clear; close all;
if ~exist('results','dir'), mkdir('results'); end

%% 1. Load data
clays  = readtable('data/clay_compositions.csv');
thermo = readtable('data/thermo_data.csv');

M_kaol = 258.16;     % g/mol, Al2Si2O5(OH)4
M_H2O  = 18.015;     % g/mol
loss_frac = 2*M_H2O/M_kaol;      % theoretical structural water loss (~13.96 %)
fprintf('Theoretical mass loss of pure kaolinite = %.2f %%\n\n', loss_frac*100);

%% 2. Mass vs temperature for each clay (TGA-style curve)
T = 25:5:1200;                              % deg C
% Dehydroxylation range 450-700 C (Onal et al. J Therm Anal Calorim; Fotsop et al. 2025)
T_mid = 575;                                % midpoint of 450-700 C
progress = 1 ./ (1 + exp(-(T - T_mid)/25)); % simple S-curve, 0 -> 1

figure('Position',[100 100 900 450]); hold on
for i = 1:height(clays)
    body_loss = clays.kaolinite_wt(i)/100 * loss_frac * 100;   % wt% of whole body
    mass = 100 - body_loss*progress;
    plot(T, mass, 'LineWidth', 2, 'DisplayName', char(clays.clay(i)));
    fprintf('%-20s kaolinite = %4.1f wt%%  ->  mass loss = %.2f %%\n', ...
        char(clays.clay(i)), clays.kaolinite_wt(i), body_loss);
end

xline(573,  '--r', 'Quartz \alpha-\beta', 'HandleVisibility','off');
xline(1000, '--g', 'Mullite / spinel',    'HandleVisibility','off');

%% 3. Overlay digitised literature TGA data (optional)
if exist('data/literature_tga.csv','file')
    lit = readtable('data/literature_tga.csv');
    plot(lit.temperature_C, lit.mass_percent, 'ks', 'MarkerFaceColor','k', ...
        'DisplayName','Literature (Cameroonian kaolin)');
end

xlabel('Temperature (^{\circ}C)'); ylabel('Mass (%)');
title('Simulated mass change during firing'); legend('Location','southwest'); grid on
saveas(gcf, 'results/mass_vs_temperature.png');

%% 4. Thermodynamics: dG = dH - T*dS
dH = thermo.dH_kJ_per_mol(1) * 1000;     % J/mol
dS = thermo.dS_J_per_molK(1);            % J/mol.K
TK = 300:10:1200;                        % K
dG = (dH - TK*dS) / 1000;                % kJ/mol
T_eq = dH/dS;                            % K, where dG = 0

figure('Position',[100 100 900 450]);
plot(TK-273.15, dG, 'LineWidth', 2); hold on
yline(0, '--k');
plot(T_eq-273.15, 0, 'ro', 'MarkerFaceColor','r');
text(T_eq-273.15+15, 5, sprintf('\\DeltaG = 0 at %.0f ^{\\circ}C', T_eq-273.15));
xlabel('Temperature (^{\circ}C)'); ylabel('\DeltaG (kJ/mol)');
title('Kaolinite dehydroxylation: \DeltaG vs T'); grid on
saveas(gcf, 'results/deltaG_vs_temperature.png');

fprintf('\nThermodynamic equilibrium temperature = %.0f C\n', T_eq-273.15);
fprintf('Source for dH, dS: %s\n', char(thermo.source(1)));
