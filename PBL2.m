%% PBL Project 2
% PBL Group 4:
% Sophia Burgueno, Anika Kulkarni, Valentina Lopez, 
% Ryan Nguyen, Krishna Ravi, Tatum Thompson, Felix Wang

% Code Contributors:
% Anika Kulkarni    Last Commit: 10/15/2025
% Krishna Ravi      Last Commit: 
% Felix Wang        Last Commit: 10/5/2025

% General Housekeeping:
% ! Use Tabs for Indents

% Overview
% -----------------------------
% ACCOUNTING EQUATION: Ψ_out = Ψ_in [1 - w_reabs + w_sec]
% <https://ibb.co/356L4rWn>
% Assuming s-s, no rxn

% END GOAL: line plot of flow rates of each component per nephronal unit
% Nephronal unit = pseudomeasure of time


% Indices
% -----------------------------
% Chemical Constituents
chemicals = ["Na+", "Cl-", "Urea", "Glucose", "K+", "HCO3-", "Mg2+", "PO4 3-", "Creatinine"];
molec_weights = [22.989, 35.453, 60.056, 180.156, 39.098, 61.020, 24.305, 94.971, 113.12]; % For gram conversion

% Nephronal Units
units = ["RC", "PT", "DL", "AL", "DT", "CD"];
% RC = Renal Corpuscle
% PT = Proximal Tubule
% DL = Descending Limb
% AL = Ascending Limb
% DT = Distal Tubule
% CD = Collecting Duct
% Corresponds to x-axis for plots

nSeg = length(units);
nSol = length(chemicals);

% Data Matrices
% -----------------------------
%{
      Na+     Cl-    Urea    Gluc     K+     HCO3-   Mg2+    PO43-   Creat  
RC | (1,1) | (1,2) | (1,3) | (1,4) | (1,5) | (1,6) | (1,7) | (1,8) | (1,9) 
PT | (2,1) | (2,2) | (2,3) | (2,4) | (2,5) | (2,6) | (2,7) | (2,8) | (2,9)  
DL | (3,1) | (3,2) | (3,3) | (3,4) | (3,5) | (3,6) | (3,7) | (3,8) | (3,9)    
AL | (4,1) | (4,2) | (4,3) | (4,4) | (4,5) | (4,6) | (4,7) | (4,8) | (4,9) 
DT | (5,1) | (5,2) | (5,3) | (5,4) | (5,5) | (5,6) | (5,7) | (5,8) | (5,9) 
CD | (6,1) | (6,2) | (6,3) | (6,4) | (6,5) | (6,6) | (6,7) | (6,8) | (6,9) 
%}

% Inlet filtrate concentrations at renal corpuscle
C0 = [140, 103, 5, 5, ]; % Na+, Cl-, Urea, Glucose, K+, HCO3-, Mg2+, PO43-, Creatinine 
% FILL THE REST

% Reabsorption fractions per constituent (of incoming stream) per unit
% This is what's returned to interstitial fluid
reabs_frac = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0; % RC
              0.65, 0.65, 0.50, 0.99, 0.65, 0.85, 0.25, 0.80,-0.20 ; % PT
              0, 0, 0, 0, 0, 0.15, 0,0,0; % DL (salt-impermeable)
              0.25, 0.25, 0, 0, 0.25, 0, 0.7, 0, 0; % AL (water-impermeable, salt-permeable)
              0.05, 0.05, 0, 0, 0, 0, 0.05, 0.05, 0 ; % DT
              0.03, 0.03, 0.40, 0, 0, 0, 0 ; % CD
             ];
% FILL THE REST

% Molar flow rates per constituent per unit
% To be solved for; preallocated for now 
molar_flow_rates = zeros(nSeg,nSol);

% Concentrations per constituent per unit
% To be solved for; preallocated for now 
concs = zeros(nSeg,nSol);

% Input concentrations
snGFR = 60 / 1000; % nL/min * 1e-3 = mL/min (filtrate into RC/Bowman's capsule for a healthy kidney)

% Volumetric flow rates per constituent per unit
vol_flow_rates = snGFR * ones(nSeg,1); % nL/min
% Set up so molar flow rate = vol flow rate * conc, so mL/min * mM = nmol/min

% Calculations
% -----------------------------
% Initialize input stream to first unit (RC)
concs(1,:) = C0;
molar_flow_rates(1,:) = snGFR .* concs(1,:); % nmol/min

% Propagate flow rates by unit/segment
for i = 2:nSeg

    % Accounting for each chemical constituent
    N_in  = molar_flow_rates(i-1,:); % Vector with inflows for all chemicals (nmol/min)
    N_out = N_in .* (1 - reabs_frac(i,:)); % Vector with outflows for all chemicals

    if N_out < 0
        errordlg("Negative Flow Rate at Row " + i + "!!!")
    end

    % Fill row i of 6x9 matrix
    molar_flow_rates(i,:) = N_out; % Given that P_out is a vector containing flow rates of all chemicals at that unit              
    concs(i,:) = molar_flow_rates(i,:) ./ vol_flow_rates(i); % nmol/min / nL/min = nmol/nL
end

% Outlets in grams/min
grams_per_min_out = zeros(1,nSol);
for j = 1:nSol
    grams_per_min_out(j) = molar_flow_rates(end,j) * molec_weights(j) * 1e-9; % nmol/min * g/mol * 1e-9 = g/min   
end

disp("Outlet (collecting duct) in grams/min per solute: ");
for k = 1:nSol
    disp(chemicals(j) + ":" + num2str(grams_per_min_out(k)));
end

% Graphs
% -----------------------------
% Display to check matrix is reasonable
disp('6x9 Molar Flow Rate Matrix (rows = RC, PT, DL, AL, DT, CD; columns = Na+, Cl-, Urea, Glucose, K+, HCO3-, Mg2+, phosphate, creatinine):');
disp(molar_flow_rates);

for k = 1:nSol
    % Concentrations
    subplot(2, nSol, k);
    plot(1:nSeg, concs(:,k), '-o', 'LineWidth', 1.5); 
    grid on;
    title(chemicals(k) + " Concentration");
    xticks(1:nSeg); 
    xticklabels(units); 
    ylabel('mM');

    % Molar flow rates
    subplot(2, nSol, nSol + k);
    plot(1:nSeg, molar_flow_rates(:,k), '-o', 'LineWidth', 1.5); 
    grid on;
    title(chemicals(k) + " Flow");
    xticks(1:nSeg); 
    xticklabels(units); 
    ylabel('nmol/min');
end


