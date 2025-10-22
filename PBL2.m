%% PBL Project 2
% PBL Group 4:
% Sophia Burgueno, Anika Kulkarni, Valentina Lopez,
% Ryan Nguyen, Krishna Ravi, Tatum Thompson, Felix Wang

% Code Contributors:
% Anika Kulkarni    Last Commit: 10/21/2025
% Krishna Ravi      Last Commit: 10/20/2025
% Felix Wang        Last Commit: 10/21/2025

% Overview
% -----------------------------
% ACCOUNTING EQUATION: Ψ_out = Ψ_in [1 - w_reabs + w_sec]

% ASSUMPTIONS:
% (1) Steady-State
% (2) No Reactions
% (3) No Leaks

% LIMITATIONS:
% (1) Water flow held constant (no ADH modulation)
% (2) Active/passive Transport not explicitly modeled
% (3) Tubuloglomerular feedback not included

% OUTPUTS:
% > Model allows for various scenarios
% (1) Mass flow rate of each chemical constituent in each unit
% (2) Concentration of each chemical constituent in each unit


% Kidney Model
% -----------------------------
function[molar_flow_rates, concs, grams_per_min_out] = kidney_model(C0, snGFR, condition)

% Indices
% -----------------------------
% Nephronal Units (x-Axis)
units = ["RC", "PT(S1)", "PT(S2)", "PT(S3)", "DL", "AL", "DT", "CD"];
% RC = Renal Corpuscle
% PT = Proximal Tubule: Split into S1, S2, S3
% DL = Descending Limb
% AL = Ascending Limb
% DT = Distal Tubule
% CD = Collecting Duct

% Chemical Constituents (y-Axis)
chemicals = ["Na^+", "Cl^-", "Urea", "Glucose", "K^+", "HCO_3^-", "Mg^{2+}", "PO_4^{3-}", "Creatinine", "Ca^{2+}"];
colors = ["#012966", "#005f73", "#0a9396", "#94d2bd", "#e9d8a6", "#ee9b00", "#ca6702", "#bb3e03", "#ae2012", "#9b2226"];
molec_weights = [22.989, 35.453, 60.056, 180.156, 39.098, 61.020, 24.305, 94.971, 113.12, 40.08]; % g/mol

% Matrix Lengths
nSeg = length(units);
nSol = length(chemicals);


% Input Data Matrices
% -----------------------------
% Fractions derived from a host of literature sources, primarily:
% - Weinstein, A. M. Seldin and Giebisch's The Kidney. Elsevier Inc., 2008. 849-887.1081-1142
% - Vallon, V. Am J Physiol Cell Physiol. 2011 Jan; 300(1): C6-C8.
% - Oregon State University, open courseware

%{
      Na+     Cl-    Urea    Gluc     K+     HCO3-   Mg2+    PO4^3-  Creat    Ca2+
RC | (1,1) | (1,2) | (1,3) | (1,4) | (1,5) | (1,6) | (1,7) | (1,8) | (1,9) | (1,10)
S1 | (2,1) | (2,2) | (2,3) | (2,4) | (2,5) | (2,6) | (2,7) | (2,8) | (2,9) | (2,10)
S2 | (3,1) | (3,2) | (3,3) | (3,4) | (3,5) | (3,6) | (3,7) | (3,8) | (3,9) | (3,10)
S3 | (4,1) | (4,2) | (4,3) | (4,4) | (4,5) | (4,6) | (4,7) | (4,8) | (4,9) | (4,10)
DL | (5,1) | (5,2) | (5,3) | (5,4) | (5,5) | (5,6) | (5,7) | (5,8) | (5,9) | (5,10)
AL | (6,1) | (6,2) | (6,3) | (6,4) | (6,5) | (6,6) | (6,7) | (6,8) | (6,9) | (6,10)
DT | (7,1) | (7,2) | (7,3) | (7,4) | (7,5) | (7,6) | (7,7) | (7,8) | (7,9) | (7,10)
CD | (8,1) | (8,2) | (8,3) | (8,4) | (8,5) | (8,6) | (8,7) | (8,8) | (8,9) | (8,10)
%}

% Reabsorption Fractions per Constituent (of incoming stream) per Unit
% This is what's returned to the interstitial fluid
% Solutes     Na+,     Cl-,     Urea,    Glucose, K+,      HCO3-,   Mg2+,    PO4^3-,  Creat,   Ca2+
reabs_frac = [0,       0,       0,       0,       0,       0,       0,       0,       0,       0;    % RC
              0.33,    0.33,    0,       0.90,    0,       0.80,    0,       0.35,    0,       0.35; % PT(S1)
              0.328,   0.328,   0,       0.09,    0,       0.10,    0,       0.25,    0,       0.25; % PT(S2)
              0.222,   0.222,   0.50,    0,       0.60,    0,       0.20,    0.10,    0,       0.10; % PT(S3)
              0,       0,       0,       0,       0,       0.15,    0,       0,       0,       0;    % DL
              0.25,    0.25,    0,       0,       0.25,    0,       0.7,     0,       0,       0.20; % AL
              0.05,    0.05,    0,       0,       0,       0.05,    0.05,    0.05,    0,       0.10; % DT
              0,       0,       0,       0,       0,       0,       0,       0,       0,       0.05; % CD
             ];
%{
 • Note: Na/Cl reabsorption can increase to 0.02/0.03 in the Collecting Duct when producing dilute urine (over-hydration) or with high salt intake (need to dilute urine)
 • Note: Urea is reabsorbed when producing concentrated urine to conserve water, as urea establishes an osmotic gradient (dehydration)
 • However, because urea reabsorption is tightly regulated by ADH and other hormones, this is outside the scope of this model
%}

% Secretion Fractions per Constituent (of incoming stream) per Unit
% This is what's secreted by the bloodstream into tubules post-RC (initial filtration)
% Solutes    Na+,     Cl-,     Urea,    Glucose, K+,      HCO3-,    Mg2+,    PO4^3-,  Creat,   Ca2+
sec_frac =   [0,      0,       0,       0,       0,       0,        0,       0,       0,       0;    % RC
              0,      0,       0,       0,       0,       0,        0,       0,       0,       0;    % PT(S1)
              0,      0,       0,       0,       0,       0,        0,       0,       0.30,    0;    % PT(S2)
              0,      0,       0,       0,       0,       0,        0,       0,       0,       0;    % PT(S3)
              0,      0,       0.15,    0,       0,       0,        0,       0,       0,       0;    % DL
              0,      0,       0,       0,       0,       0,        0,       0,       0,       0;    % AL
              0,      0,       0,       0,       0.10,    0,        0,       0,       0,       0;    % DT
              0,      0,       0,       0,       0.10,    0,        0,       0,       0,       0;    % CD
              ];

% Safety Clamps
reabs_frac = max(0, min(reabs_frac, 0.999));
sec_frac = max(0, min(sec_frac, 0.999));


% Calculated Data Matrices
% -----------------------------
% Molar Flow Rates per Constituent per Unit
molar_flow_rates = zeros(nSeg,nSol); % mmol/min

% Mass Flow Rates per Constituent leaving Collecting Duct (Outlet)
grams_per_min_out = zeros(1,nSol); % g/min

% Concentrations per Constituent per Unit
concs = zeros(nSeg,nSol); % mmol/L = mM

% Volumetric flow rates per constituent per unit
vol_flow_rates = snGFR * ones(nSeg,1); % mL/min


% Input Parameters
% -----------------------------
% Initializes input stream (C0 & snGFR) to Renal Corpuscle
%{
 molar_flow_rates = vol_flow_rates * concs
 mmol/min         = mL/min * mM * 1L/1000mL
%}

concs(1,:) = C0; % mmol/L = mM
molar_flow_rates(1,:) = snGFR .* concs(1,:) * 1e-3; % mmol/min


% Adjustments
% -----------------------------
% Adjusts secretion fractions in the Collecting Duct for Na+ in the event of high salt intake
if concs(1,1) > 140 && concs(1,2) > 106
      sec_frac(8,1) = 0.02;  % Na+
      sec_frac(8,2) = 0.03;  % Cl-    
end


% Calculations
% -----------------------------
% Calculates molar flow rates and concentrations for each unit
for i = 2:nSeg
    % Accounting for Each Constituent
    N_in  = molar_flow_rates(i-1,:); % Vector with inflows for all constituents
    N_out = N_in .* (1 - reabs_frac(i,:) + sec_frac(i,:)); % Vector with outflows for all constituents

    if any(N_out < 0)
        errordlg("Negative Flow Rate at Row " + i + "!!!") % Error Warning
    end

    % Populates row i of Data Matrix
    molar_flow_rates(i,:) = N_out; % mmol/min
    concs(i,:) = molar_flow_rates(i,:) ./ vol_flow_rates(i); % mmol/min / mL/min = mmol/L
end

% Converts outlet molar flow rates to mass flow rates
for j = 1:nSol
    grams_per_min_out(j) = molar_flow_rates(end,j) * molec_weights(j) * 1e-3; % mmol/min * g/mol * 1e-3 = g/min
end


% Print
% -----------------------------
% Molar Flow Rates
fprintf("\n\n" + condition + "\n--------------------------\n");

fprintf("8x10 Molar Flow Rate Matrix\n" + ...
    "• Rows = RC, S1, S2, S3, DL, AL, DT, CD\n" + ...
    "• Columns = Na+, Cl-, Urea, Glucose, K+, HCO3-, Mg2+, PO4^3-, Creatinine, Ca2+");
disp(molar_flow_rates);

% Concentrations
fprintf("8x10 Concentrations Matrix\n" + ...
    "• Rows = RC, S1, S2, S3, DL, AL, DT, CD\n" + ...
    "• Columns = Na+, Cl-, Urea, Glucose, K+, HCO3-, Mg2+, PO4^3-, Creatinine, Ca2+");
disp(concs);

% Outlet Mass Flow Rates
disp("Outlet (collecting duct) in grams/min per solute: ");
for k = 1:nSol
    disp(chemicals(k) + ": " + num2str(grams_per_min_out(k)));
end


% Graphs
% -----------------------------
fig = figure('Name', condition, 'Units', 'normalized', 'Position', [0.05 0.05 0.9 0.8]);

% Adds tabs to figure
tabGroup = uitabgroup(fig);
tab1 = uitab(tabGroup, 'Title', 'Concentrations');
tab2 = uitab(tabGroup, 'Title', 'Molar Flow Rates');
tab3 = uitab(tabGroup, 'Title', 'Outlet Mass Flow Rates');

% Display layout for graphs
tLayout1 = tiledlayout(tab1, 2, 5, 'TileSpacing', 'compact', 'Padding', 'compact');
tLayout2 = tiledlayout(tab2, 2, 5, 'TileSpacing', 'compact', 'Padding', 'compact');

% Figure 1: Concentrations
for k = 1:nSol
    ax1 = nexttile(tLayout1);
    plot(ax1, 1:nSeg, concs(:,k), '-', 'Color', colors(k), 'LineWidth', 2);
    grid on
    title(chemicals(k) + " Concentration", 'FontWeight','bold', 'FontSize', 12)
    xticks(1:nSeg)
    xticklabels(units)
    ylabel('mM')
    ylim([0 inf])
end
sgtitle({"Solute Concentrations Along Nephron Segments", "Test Case: " + condition}, 'FontSize', 14, 'FontWeight','bold')

% Figure 2: Molar Flow Rates
for k = 1:nSol
    ax2 = nexttile(tLayout2);
    plot(ax2, 1:nSeg, molar_flow_rates(:,k), '-', 'Color', colors(k), 'LineWidth', 2);
    grid on
    title(chemicals(k) + " Molar Flow", 'FontWeight','bold', 'FontSize', 12)
    xticks(1:nSeg)
    xticklabels(units)
    ylabel('mmol/min')
    ylim([0 inf])
end
sgtitle({"Molar Flow Rates Along Nephron Segments", "Test Case: " + condition}, 'FontSize', 14, 'FontWeight','bold')

% Figure 3: Outlet Mass Flow Rates
axes('Parent', tab3);
b = bar(1:nSol, grams_per_min_out);
b.FaceColor = 'flat'; 
for k = 1:nSol
    b.CData(k,:) = hex2rgb(colors(k));
end
grid on
xticks(1:nSol)
xticklabels(chemicals)
ylabel('g/min')
ylim([0 inf])
sgtitle({"Outlet Mass Flow Rates Along Nephron Segments", "Test Case: " + condition}, 'FontSize', 14, 'FontWeight','bold')

end

% Test Cases
% -----------------------------
function[conc_out, snGFR_out] = test_cases(C0, snGFR, condition)
% Implements test cases by adjusting inlet concentrations and single-nephron GFR accordingly
% Test Cases: 'healthy', 
%             'ckd3b' (CKD, stage 3b),
%             't2dm_early' (early type 2 diabetes),
%             't2dm_late' (late type 2 diabetes),
%             'htn' (hypertension)

% Re-indexing for convenience
Na = 1;
Cl = 2;
Urea = 3;
Gluc = 4;
K = 5;
HCO3 = 6;
Mg = 7;
PO4 = 8;
Creat = 9;
Ca = 10;

switch lower(condition)
    case 'healthy'
        % No change, using base values

    case 'ckd3b'
        % We are modeling stage 3b as this marks substantial loss of kidney function and sure-fire diagnosis of CKD

        % Normal GFR = 90-120 mL/min; Stage 3b GFR = 30-44 mL/min
        % Scaling factor as reference as snGFR values not available
        snGFR = snGFR * 37/105; % Using a scaling factor as reference as snGFR values not available

        % Creatinine level increased by 60% 
        % Typical creatinine level: 0.7-1.3 mg/dL in males, 0.6-1.1 mg/dL in females
        % CKD3b creatinine level: 1.2-2.0 mg/dL in males, 1.8-3.0 mg/dL in females
        % 50-70% increase
        C0(Creat) = C0(Creat) * 1.6; 

        % Urea level increased by 40% (estimate)
        C0(Urea) = C0(Urea) * 1.4; 

        % Potassium level increased by 15% (estimate; hyperkalemia)
        C0(K) = C0(K) * 1.15;

        % Phosphate level increased by 25% (estimate; due to degradation of phosphate secretion)
        C0(PO4) = C0(PO4) * 1.25;
        
        % Bicarbonate level decreased, not significantly (sign of metabolic acidosis)
        C0(HCO3) = C0(HCO3) * 0.90;

        % Calcium level decreased, not significantly (sign of hypocalcemia)
        C0(Ca) = C0(Ca) * 0.90;
    
    case 't2dm_early'
        % Separating early and late stages because early T2DM = hyperfiltration
        
        % Normal GFR = 120 mL/min; Early T2DM GFR = 120-150 mL/min, median at 135 mL/min
        % Approximating hyperfiltration
        snGFR = snGFR * 1.125;

        % Average plasma concentration of glucose during early hyperglycemia
        C0(Gluc) = 7; % 7 mmol/L = 126 mg/dL

    case 't2dm_late'
        % Separating early and late stages because late T2DM = hypofiltration

        % Normal GFR = 90-120 mL/min; Late T2DM GFR = 15-29 mL/min, median at 22 mL/min (correlated with Stage 4-5 CKD)
        % Approximating hypofiltration
        snGFR = snGFR * 22/105;

        % Average plasma concentration of glucose during late stage hyperglycemia
        C0(Gluc) = 9.7; % 8.3-11.1 mmol/L

        % Potassium level jumps to greater than 6 mmol/L
        C0(K) = C0(K) * 1.30; % Jumps to greater than 6 mmol/L

        % Phosphate level jumps to greater than 1.5 mmol/L
        C0(PO4) = C0(PO4) * 1.15; % Jumps to greater than 1.5 mmol/L

        % Bicarbonate level decreases but still indicative of metabolic acidosis
        C0(HCO3) = C0(HCO3) * 0.85;

    case 'htn'
        % Slight decrease to reflect vascular damage
        snGFR = snGFR * 0.90;
end

% Outputs
conc_out = C0;
snGFR_out = snGFR;

end


% Main Code
% -----------------------------
% BASELINE INLET CONCENTRATIONS
% Inlet filtrate concentrations at renal corpuscle, as INPUT into main function

% Na+, Cl-, Urea, Glucose, K+, HCO3-, Mg2+, PO4^3-, Creatinine, Ca2+ 
C0 = [140.0000, 102.0000, 5.714, 4.6905, 4.3500, 24.0000, 0.8225, 0.3950, 0.0920, 0.5700]; % mmol/L

% Filtrate into RC/Bowman's capsule for a healthy kidney
% A healthy kidney has a single-nephron GFR of approximately 79 +/- 42 nanoliters per minute (nL/min)
snGFR = 79 / 1000; % nL/min * 1e-3 = mL/min (filtrate into RC/Bowman's capsule for a healthy kidney)

% Healthy
[C0_h, sn_h] = test_cases(C0, snGFR, 'healthy');
kidney_model(C0_h, sn_h, "Healthy");

% CKD3b
[C0_ckd, sn_ckd] = test_cases(C0, snGFR, 'ckd3b');
kidney_model(C0_ckd, sn_ckd, "CKD3b");

% T2DM Early
[C0_dme, sn_dme] = test_cases(C0, snGFR, 't2dm_early');
kidney_model(C0_dme, sn_dme, "T2DM (Early)");

% T2DM Late
[C0_dml, sn_dml] = test_cases(C0, snGFR, 't2dm_late');
kidney_model(C0_dml, sn_dml, "T2DM (Late)");

% Hypertension
[C0_htn, sn_htn] = test_cases(C0, snGFR, 'htn');
kidney_model(C0_htn, sn_htn, "Hypertension");

% Combination of all 3, modeling severe CKD 
[C0_tmp,  sn_tmp]  = test_cases(C0, snGFR, 'ckd3b');
[C0_tmp,  sn_tmp]  = test_cases(C0_tmp, sn_tmp, 'htn');
[C0_combo, sn_combo] = test_cases(C0_tmp, sn_tmp, 't2dm_late');
kidney_model(C0_combo, sn_combo, "CKD3b + HTN + T2DM (Late)");