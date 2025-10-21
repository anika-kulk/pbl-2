%% PBL Project 2
% PBL Group 4:
% Sophia Burgueno, Anika Kulkarni, Valentina Lopez, 
% Ryan Nguyen, Krishna Ravi, Tatum Thompson, Felix Wang

% Code Contributors:
% Anika Kulkarni    Last Commit: 10/21/2025
% Krishna Ravi      Last Commit: 10/20/2025
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

function[molar_flow_rates, concs] = kidney_model(C0, snGFR)

% Indices
% -----------------------------
% Chemical Constituents
chemicals = ["Na+", "Cl-", "Urea", "Glucose", "K+", "HCO3-", "Mg2+", "PO4 3-", "Creatinine", "Ca2+"];
molec_weights = [22.989, 35.453, 60.056, 180.156, 39.098, 61.020, 24.305, 94.971, 113.12, 40.08]; % For gram conversion; in g/mol

% Nephronal Units
units = ["RC", "PT, S1", "PT, S2", "PT, S3", "DL", "AL", "DT", "CD"];
% RC = Renal Corpuscle
% PT = Proximal Tubule, split into S1, S2, and S3
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
      Na+     Cl-    Urea    Gluc     K+     HCO3-   Mg2+    PO43-   Creat    Ca2+
RC | (1,1) | (1,2) | (1,3) | (1,4) | (1,5) | (1,6) | (1,7) | (1,8) | (1,9) | (1,10)
S1 | (2,1) | (2,2) | (2,3) | (2,4) | (2,5) | (2,6) | (2,7) | (2,8) | (2,9) | (2,10)
S2 | (3,1) | (3,2) | (3,3) | (3,4) | (3,5) | (3,6) | (3,7) | (3,8) | (3,9) | (3,10)    
S3 | (4,1) | (4,2) | (4,3) | (4,4) | (4,5) | (4,6) | (4,7) | (4,8) | (4,9) | (4,10)  
DL | (5,1) | (5,2) | (5,3) | (5,4) | (5,5) | (5,6) | (5,7) | (5,8) | (5,9) | (5,10)  
AL | (6,1) | (6,2) | (6,3) | (6,4) | (6,5) | (6,6) | (6,7) | (6,8) | (6,9) | (6,10)  
DT | (7,1) | (7,2) | (7,3) | (7,4) | (7,5) | (7,6) | (7,7) | (7,8) | (7,9) | (7,10)  
CD | (8,1) | (8,2) | (8,3) | (8,4) | (8,5) | (8,6) | (8,7) | (8,8) | (8,9) | (8,10)  
%}

% Reabsorption fractions per constituent (of incoming stream) per unit
% This is what's returned to interstitial fluid
% Solutes    Na+,     Cl-,     Urea,    Glucose, K+,      HCO3-,   Mg2+,    PO43-,   Creat,   Ca2+ 
reabs_frac = [0,       0,       0,       0,       0,       0,       0,       0,       0,       0;    % RC
              0.33,    0.33,    0,       0.90,    0,       0.80,    0,       0.35,    0,       0.35; % PT, S1
              0.328,   0.328,   0,       0.09,    0,       0.10,    0,       0.25,    0,       0.25; % PT, S2
              0.222,   0.222,   0.50,    0,       0.60,    0,       0.20,    0.10,    0,       0.10; % PT, S3
              0,       0,       0,       0,       0,       0.15,    0,       0,       0,       0;    % DL (salt-impermeable)
              0.25,    0.25,    0,       0,       0.25,    0,       0.7,     0,       0,       0.20; % AL (water-impermeable, salt-permeable)
              0.05,    0.05,    0,       0,       0,       0.05,    0.05,    0.05,    0,       0.10; % DT
              0,       0,       0,       0,       0,       0,       0,       0,       0,       0.05; % CD
             ];
% Note that Na/Cl reabsorption can increase to 0.02/0.03 when producing dilute urine (over-hydration); also when high salt intake (need to dilute urine)
% Note that urea is reabsorbed when producing concentrated urine to conserve water, as urea establishes an osmotic gradient (de-hydration)
      % However, because this is tightly regulated by ADH and other hormones, this is outside the scope of this model
reabs_frac = max(0, min(reabs_frac, 0.999)); % Safety clamp

% Secretion fractions per constituent (of incoming stream) per unit
% This is what's secreted by bloodstream into tubule post-RC (initial filtration)
% Solutes    Na+,     Cl-,     Urea,    Glucose, K+,      HCO3-,   Mg2+,    PO43-,   Creat,   Ca2+ 
sec_frac =   [0,       0,       0,       0,       0,       0,       0,       0,       0,       0; % RC
              0,       0,       0,       0,       0,       0,       0,       0,       0,       0; % PT, S1
              0,       0,       0,       0,       0,       0,       0,       0,       0.30,    0; % PT, S2
              0,       0,       0,       0,       0,       0,       0,       0,       0,       0; % PT, S3
              0,       0,       0.15,    0,       0,       0,       0,       0,       0,       0; % DL (salt-impermeable)
              0,       0,       0,       0,       0,       0,       0,       0,       0,       0; % AL (water-impermeable, salt-permeable)
              0,       0,       0,       0,       0.10,    0,       0,       0,       0,       0; % DT
              0,       0,       0,       0,       0.10,    0,       0,       0,       0,       0; % CD
             ];
sec_frac = max(0, min(sec_frac, 0.999)); % Safety clamp

% Molar flow rates per constituent per unit
% To be solved for; preallocated for now 
molar_flow_rates = zeros(nSeg,nSol);

% Concentrations per constituent per unit
% To be solved for; preallocated for now 
concs = zeros(nSeg,nSol); % mmol/L

% Volumetric flow rates per constituent per unit
vol_flow_rates = snGFR * ones(nSeg,1); % mL/min
% Set up so molar flow rate = vol flow rate * conc, so mL/min * mM * 1 L/1000 mL = mmol/min

% Calculations
% -----------------------------
% Initialize input stream to first unit (RC)
concs(1,:) = C0; % mmol/L, aka mM; TAKEN AS INPUT
molar_flow_rates(1,:) = snGFR .* concs(1,:) * 1e-3; % mmol/min; snGFR TAKEN AS INPUT

% Conditional
% -----------------------------
% Adjust reabsorption fractions for salt in the case of high salt intake - whether a one-off event or hypernatremia/hyperchloremia
if concs(1, 1) > 140.0000 & concs(1, 2) > 106
      reabs_frac(8,1) = 0.02
      reabs_frac(8,2) = 0.03
end

% Math Propagation
% -----------------------------
% Propagate flow rates by unit/segment
for i = 2:nSeg

    % Accounting for each chemical constituent
    N_in  = molar_flow_rates(i-1,:); % Vector with inflows for all chemicals (mmol/min)
    N_out = N_in .* (1 - reabs_frac(i,:) + sec_frac(i,:)); % Vector with outflows for all chemicals

    if any(N_out < 0)
        errordlg("Negative Flow Rate at Row " + i + "!!!")
    end

    % Fill row i of 8x10 matrix
    molar_flow_rates(i,:) = N_out; % Given that P_out is a vector containing flow rates of all chemicals at that unit              
    concs(i,:) = molar_flow_rates(i,:) ./ vol_flow_rates(i); % mmol/min / mL/min = mmol/L
end

% Outlets in grams/min
grams_per_min_out = zeros(1,nSol);
for j = 1:nSol
    grams_per_min_out(j) = molar_flow_rates(end,j) * molec_weights(j) * 1e-3; % mmol/min * g/mol * 1e-3 = g/min   
end

disp("Outlet (collecting duct) in grams/min per solute: ");
for k = 1:nSol
    disp(chemicals(k) + ":" + num2str(grams_per_min_out(k)));
end

% Graphs
% -----------------------------
% Display to check matrix is reasonable
disp('8x10 Molar Flow Rate Matrix (rows = RC, S1, S2, S3, DL, AL, DT, CD; columns = Na+, Cl-, Urea, Glucose, K+, HCO3-, Mg2+, phosphate, creatinine, Ca2+):');
disp(molar_flow_rates);

colors = ["#012966", "#005f73", "#0a9396", "#94d2bd", "#e9d8a6", ...
          "#ee9b00", "#ca6702", "#bb3e03", "#ae2012", "#9b2226"];

% Figure 1: Concentrations
figure('Units','normalized','Position',[0.05 0.05 0.9 0.8])
tiledlayout(2, 5, 'TileSpacing','compact', 'Padding','compact')

for k = 1:nSol
    nexttile
    plot(1:nSeg, concs(:,k), '-', 'Color', colors(k), 'LineWidth', 2);
    grid on
    title(chemicals(k) + " Concentration", 'FontWeight','bold', 'FontSize', 12)
    xticks(1:nSeg)
    xticklabels(units)
    ylabel('mM')
    ylim('auto')
end

sgtitle('Solute Concentrations Along Nephron Segments', 'FontSize', 14, 'FontWeight','bold')


% Figure 2: Flow Rates
figure('Units','normalized','Position',[0.05 0.05 0.9 0.8])
tiledlayout(2, 5, 'TileSpacing','compact', 'Padding','compact')

for k = 1:nSol
    nexttile
    plot(1:nSeg, molar_flow_rates(:,k), '-', 'Color', colors(k), 'LineWidth', 2);
    grid on
    title(chemicals(k) + " Flow", 'FontWeight','bold', 'FontSize', 12)
    xticks(1:nSeg)
    xticklabels(units)
    ylabel('mmol/min')
    ylim('auto')
end

sgtitle('Molar Flow Rates Along Nephron Segments', 'FontSize', 14, 'FontWeight','bold')

end

% Inputs
% -----------------------------

% DEFAULT TEST CASE: healthy kidney
% Inlet filtrate concentrations at renal corpuscle, as INPUT into main function
C0 = [140.0000, 102.0000, 5.714, 4.6905, 4.3500, 24.0000, 0.8225, 0.3950, 0.0920, 0.5700]; % Na+, Cl-, Urea, Glucose, K+, HCO3-, Mg2+, PO43-, Creatinine, Ca2+ 
% In mmol/L

% Input concentrations
snGFR = 79 / 1000; % nL/min * 1e-3 = mL/min (filtrate into RC/Bowman's capsule for a healthy kidney)
% A healthy kidney has a single-nephron GFR of approximately 79 +/- 42 nanoliters per minute (nL/min).

kidney_model(C0, snGFR)













