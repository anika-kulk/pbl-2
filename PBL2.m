%% PBL Project 2
% PBL Group 4:
% Sophia Burgueno, Anika Kulkarni, Valentina Lopez, 
% Ryan Nguyen, Krishna Ravi, Tatum Thompson, Felix Wang

% Code Contributors:
% Anika Kulkarni    Last Commit: 10/5/2025
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
chemicals = ["H2O", "Na+", "Cl-", "Urea", "Glucose", "K+", "HCO3-"];
% Add creatinine (?)

% Nephronal Units
units = ["RC", "PT", "DL", "AL", "DT", "CD"]
% RC = Renal Corpuscle
% PT = Proximal Tubule
% DL = Descending Limb
% AL = Ascending Limb
% DT = Distal Tubule
% CD = Collecting Duct


% Data Matrices
% -----------------------------
%{
      H2O     Na+     Cl-    Urea    Gluc     K+     HCO3-
RC | (1,1) | (1,2) | (1,3) | (1,4) | (1,5) | (1,6) | (1,7) |
PT | (2,1) | (2,2) | (2,3) | (2,4) | (2,5) | (2,6) | (2,7) |
DL | (3,1) | (3,2) | (3,3) | (3,4) | (3,5) | (3,6) | (3,7) |
AL | (4,1) | (4,2) | (4,3) | (4,4) | (4,5) | (4,6) | (4,7) |
DT | (5,1) | (5,2) | (5,3) | (5,4) | (5,5) | (5,6) | (5,7) |
CD | (6,1) | (6,2) | (6,3) | (6,4) | (6,5) | (6,6) | (6,7) |
%}

rng("default")

% Reabsorption fractions per constituent (of incoming stream) per unit
% This is what's returned to interstitial fluid
reabs_frac = rand(6,7); % Testing
%{
reabs_frac = [0, 0, 0, 0, 0, 0, 0 ; % RC
              0, 0, 0, 0, 0, 0, 0 ; % PT
              0, 0, 0, 0, 0, 0, 0 ; % DL (salt-impermeable)
              0, 0, 0, 0, 0, 0, 0 ; % AL (water-impermeable, salt-permeable)
              0, 0, 0, 0, 0, 0, 0 ; % DT
              0, 0, 0, 0, 0, 0, 0 ; % CD
             ]
%}

% Secretion fractions per constituent (of incoming stream) per unit
% This is what's secreted from the blood
sec_frac = rand(6,7); % Testing
%{
sec_frac = [0, 0, 0, 0, 0, 0, 0 ; % RC
            0, 0, 0, 0, 0, 0, 0 ; % PT
            0, 0, 0, 0, 0, 0, 0 ; % DL
            0, 0, 0, 0, 0, 0, 0 ; % AL
            0, 0, 0, 0, 0, 0, 0 ; % DT
            0, 0, 0, 0, 0, 0, 0 ; % CD
           ]
%}

% Plasma/filtrate fractions
mass_fracs = [ ];

% Flow rates per constituent per unit
% To be solved for; preallocated for now 
flow_rates = zeros(6,7);

% Amounts per constituent per unit
% To be solved for; preallocated for now 
amounts = zeros(6,7);


% Calculations
% -----------------------------
% Input concentrations
GFR = 120; % mL/min (filtrate into RC/Bowman's capsule for a healthy kidney)

% Initialize input stream to first unit (RC)
Fin0 = GFR; % Initial overall flow rate = GFR (where F = filtrate)

% Flow Rates
for i = 1:length(units)

    % Accounting for each chemical constituent
    P_in  = GFR .* Fin0; % P for psi lmao; vector with inflows for all chemicals
    P_out = P_in .* (1 - reabs_frac(i,:) + sec_frac(i,:)); % Vector with outflows for all chemicals

    % Fill row i of 6x7 matrix
    flow_rates(i,:) = P_out; % Given that P_out is a vector containing flow rates of all chemicals at that unit              

end

Amounts0 = 100000 .* [1, 1, 1, 1, 1, 1, 1]; % Tunable starting amounts
Times0 = [1, 1, 1, 1, 1, 1, 1]; % Tunable times in each Nephron Unit

% Amounts
for i = 1:length(units)

    if (i==1)
        amounts(i,:) = Amounts0 - flow_rates(i,:) .* Times0(i);
    else
        amounts(i,:) = amounts(i-1,:) - flow_rates(i,:) .* Times0(i);
    end
    % Error Notification
    if (amounts(i,:) < 0)
        errordlg("Negative Amount Value at Row " + i + "!!!")
    end
end


% Graphs
% -----------------------------
% Display to check matrix is reasonable
disp("6x7 Flow Rate Matrix (rows = RC, PT, DL, AL, DT, CD; columns = H2O, Na+, Cl-, Urea, Glucose, K+, HCO3-):");
disp(flow_rates);

% Line plot of chemical constituent flow rates per unit index
figure("Name", "Chemical Constitutent Flow Rates");
hold on; grid on;
colors = ["r", "y" "g", "c", "b", "m", "k"];
% LET ANIKA CHOOSE COLORS PLEASE
% ogey - Felix

title("Chemical Constituent Flow Rate per Unit");
xlabel("Nephron Unit");
ylabel("Flow Rate (idk units)");
xticks(1:length(units)); xticklabels(units);
legend(units)

for j = 1:length(chemicals)
    plot(flow_rates(:, j), "-o", "Color", colors(j), "DisplayName", chemicals(j));
end

% Line plots of chemical constituent amount per unit index
figure("Name", "Chemical Constitutent Amounts");
hold on; grid on;
title("Chemical Constitutent Amounts");

for n = 1:length(chemicals)
    subplot(3,3,n);
    plot(amounts(:,n), "-o", "Color", colors(n), "DisplayName", chemicals(n));
    title(chemicals(n));
    xlabel("Nephron Unit"); ylabel("Amount");
    xticks(1:length(units)); xticklabels(units);
    ylim([0,inf])
end
