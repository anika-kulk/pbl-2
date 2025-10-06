%% PBL Project 2
% PBL Group 4:
% Sophia Burgueno, Anika Kulkarni, Valentina Lopez, 
% Ryan Nguyen, Krishna Ravi, Tatum Thompson, Felix Wang

% Code Contributors:
% Anika Kulkarni    Last Commit: 10/5/2025
% Krishna Ravi      Last Commit: 
% Felix Wang        Last Commit: 10/3/2025

% General Housekeeping:
% ! Use Tabs for Indents


disp("It's so over")

clear; 
clc;

% Chemical constituents index
chemicals = ["H2O", "Na+", "Cl-", "Urea", "Glucose", "K+", "HCO3-"];
% Add creatinine (?)

% Nephronal units index
units = ["RC", "PT", "DL", "AL", "DT", "CD"]
% RC = renal corpuscle
% PT = proximal tubule
% DL = descending limb
% AL = ascending limb
% DT = distal tubule
% CD = collecting duct

% Matrix of reabsorption fractions per constituent per unit
reabs_frac = []; % This is what's returned to interstitial fluid

% Matrix of secretion fractions per constituent per unit
sec_frac = []; % This is what's secreted from the blood

% Matrix of flow rates per constituent per unit
% To be solved for; preallocated for now 
flow_rates = zeros(reabs_frac);

% ACCOUNTING EQUATION: Ψ out = Ψ in [ 1 - w reabs + w sec ]
% Assuming s-s, no rxn

% END GOAL: line plot of flow rates of each component per nephronal unit
% Nephronal unit = pseudomeasure of time

% Input concentrations
GFR = 120; % mL/min (filtrate into RC/Bowman's capsule for a healthy kidney)
% Plasma/filtrate fractions in order: H20, Na+, Cl-, Urea, Glucose, K+, HCO3-
Win0 = [ ];

% Solute reabsorption/secretion fractions (of incoming stream) per unit
% rows = units (RC, PT, DL, AL, DT, CD)
% columns = chemicals in order: H20, Na+, Cl-, Urea, Glucose, K+, HCO3-

reabs_frac = [ 0,    0,   0,   0,    0,    0,    0 ;   % RC
               ; % PT
               ; % DL (salt-impermeable)
               ; % AL (water-impermeable, salt-permeable)
               ; % DT
               ; % CD
             ]

sec_frac   = [ ;   % RC
               ; % PT
               ; % DL
               ; % AL
               ; % DT 
               ; % CD
             ] 

% Initialize input stream to first unit (RC)

Fin0 = GFR; % Initial overall flow rate = GFR (where F = filtrate)

for i = 1:length(units)

    % Accounting for each chemical constituent
    Pin  = GFR .* Fin0; % P for psi lmao
    Pout = Pin .* (1 - reabs_frac(i, :) + sec_frac(i, :));

    % Fill row i of 6x7 matrix
    flow_rates(i, 1) = Pout;                

end

% Display to check matrix is reasonable
disp("6x7 flow rate matrix (rows = RC, PT, DL, AL, DT, CD; columns = H2O, Na+, Cl-, Urea, Glucose, K+, HCO3-):");
disp(flow_rates);

% Line plot of chemical constituent flow rates per unit index
figure; 
hold on;

colors = ["r", "y" "g", "c", "b", "m", "k"]
% LET ANIKA CHOOSE COLORS PLEASE

for j = 1:length(chemicals)
    plot(units, flow_rates(:, j), "-o", 'DisplayName', colors(j), chemicals(j));
end

xticks(length(units)); 
xticklabels(units);
xlabel("Nephron Unit"); 
ylabel("Flow Rate (idk units)");
title("Chemical Constituent Flow Rate per Unit");
grid on;

