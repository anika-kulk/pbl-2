## Model
$$\text{Renal Corpuscle}⠀\longrightarrow⠀\text{Proximal Tubule: S1/S2/S3}⠀\longrightarrow⠀\text{Descending Limb}⠀\longrightarrow⠀\text{Ascending Limb}⠀\longrightarrow⠀\text{Distal Tubule}⠀\longrightarrow⠀\text{Collecting Duct}$$

<br>

## Conservation Equation
For Each Solute $s$ in 1 Nephron Unit:

$$\text{In }-\text{ Out }-{\color{green}\text{ Reabsorbed }}+{\color{red}\text{ Secreted }}~~=~~0$$

- *Assuming steady-state system, no reactions*
- $\color{green}\text{Reabsorbed}$ = *From filtrate into interstitial fluid*
- $\color{red}\text{Secreted}$ = *From bloodstream into filtrate*
<br>

To Calculate the Flow Rate per Unit, Rearrange the Conservation Equation:

$$\text{ Out}⠀=⠀\text{In }-{\color{green}\text{ Reabsorbed }}+{\color{red}\text{ Secreted }}$$

## Equation Form
$$\dot\psi_{reabs}⠀=⠀\dot\psi_{in}w_{reabs}$$
$$\dot\psi_{sec}⠀=⠀\dot\psi_{in}w_{sec}$$

$$\begin{array}{l}
\dot\psi_{out}&=&\dot\psi_{in}⠀-⠀\dot\psi_{reabs}⠀+⠀\dot\psi_{sec}\\
&=&\dot\psi_{in}⠀-⠀\dot\psi_{in}(w_{reabs}) + \dot\psi_{in}(w_{sec})\\
&=&\dot\psi_{in}[1~-~w_{reabs} + w_{sec}]
\end{array}$$


## Data
Mass Reabsorbption & Secretion Fractions will be stored in a $8\times 10$ Matrix
- Each Row is a Nephronal Unit
- Each Column is a Selected Chemical Constituent

$$\text{reabs}\textunderscore\text{frac}()$$
$$\begin{bmatrix}
&\text{⠀Na}^+⠀&\text{⠀Cl}^-⠀&\text{ Urea }&\text{Glucose}&⠀\text{K}^+⠀&\text{HCO}_3^-&\text{⠀Mg}^{2+}⠀&\text{PO}_4^{3-}&\text{Creatinine}&⠀\text{Ca}^{2+}⠀\\
\text{RP}_1&0     &0     &0    &0    &0    &0    &0    &0    &0 &0\\
\text{S1}_2&0.33  &0.33  &0    &0.90 &0    &0.80 &0    &0.35 &0 &0.35\\
\text{S2}_3&0.328 &0.328 &0    &0.09 &0    &0.10 &0    &0.25 &0 &0.25\\
\text{S3}_4&0.222 &0.222 &0.50 &0    &0.60 &0    &0.20 &0.10 &0 &0.10\\
\text{DL}_5&0     &0     &0    &0    &0    &0.15 &0    &0    &0 &0\\
\text{AL}_6&0.25  &0.25  &0    &0    &0.25 &0    &0.7  &0    &0 &0.20\\
\text{DT}_7&0.05  &0.05  &0    &0    &0    &0.05 &0.05 &0.05 &0 &0.10\\
\text{CD}_8&0-0.02&0-0.03&0    &0    &0    &0    &0    &0    &0 &0.05\\
\end{bmatrix}$$

<br>

$$\text{sec}\textunderscore\text{frac}()$$
$$\begin{bmatrix}
&\text{⠀Na}^+⠀&\text{⠀Cl}^-⠀&\text{ Urea }&\text{Glucose}&⠀\text{K}^+⠀&\text{HCO}_3^-&\text{⠀Mg}^{2+}⠀&\text{PO}_4^{3-}&\text{Creatinine}&⠀\text{Ca}^{2+}⠀\\
\text{RP}_1&0 &0 &0    &0 &0    &0 &0 &0 &0    &0 \\
\text{S1}_2&0 &0 &0    &0 &0    &0 &0 &0 &0    &0 \\
\text{S2}_3&0 &0 &0    &0 &0    &0 &0 &0 &0.30 &0 \\
\text{S3}_4&0 &0 &0    &0 &0    &0 &0 &0 &0    &0 \\
\text{DL}_5&0 &0 &0.15 &0 &0    &0 &0 &0 &0    &0 \\
\text{AL}_6&0 &0 &0    &0 &0    &0 &0 &0 &0    &0 \\
\text{DT}_7&0 &0 &0    &0 &0.10 &0 &0 &0 &0    &0 \\
\text{CD}_8&0 &0 &0    &0 &0.10 &0 &0 &0 &0    &0 \\
\end{bmatrix}$$

<br>

Initial Concentrations of Chemical Constituents in Filtrate

$$\text{concs}()$$
$$\begin{bmatrix}
\text{⠀⠀Na}^+⠀&\text{⠀Cl}^-⠀&\text{ ⠀Urea⠀ }&\text{Glucose}&⠀\text{K}^+⠀&\text{HCO}_3^-&\text{⠀Mg}^{2+}⠀&\text{PO}_4^{3-}&\text{Creatinine}&⠀\text{Ca}^{2+}⠀\\
140.0000 & 102.0000 & 5.714 & 4.6905 & 4.3500 & 24.0000 & 0.8225 & 0.3950 & 0.0920 & 0.5700
\end{bmatrix}\frac{\text{mmol}}{\text{L}}$$

<br>

## Pseudocode
1. Initializes vectors for `Chemicals`, `Nephronal Units`, `Inlet Filtrate Concentrations`, and `Molar Flow Rates`
2. Initializes data matrix for `Reabsorption Fractions` and `Secretion Fractions`
3. Initializes starting values at Renal Corpuscle: `Inlet Filtrate Concentrations`
4. Calculates the snGFR based on test cases

$$\text{snGFR, basal}⠀=⠀\frac{79}{1000}$$
$$\text{Unit: }\color{grey}\left(\frac{\text{mL}}{\text{min}}\right)$$

<br>

5. Calculates the `Volumetric Flow Rate per Constituent per Unit`

$$\text{Volumetric Flow Rate}⠀=⠀\text{snGFR}$$
$$\text{Unit: }\color{grey}\left(\frac{\text{cm}^3}{\text{min}}\right)$$

<br>

6. Calculates the `Molar Flow Rates` for each Nephronal Unit starting at the Proximal Tubule

$$\begin{array}{l}
\dot n_{in}&=&\text{Molar Flow Rates}(\text{Previous Unit})\\
\dot n_{out}&=&\dot n_{in}\text{ }\times\text{ }[1-\text{Reabsorbption Fractions}(\text{Current Unit})]
\end{array}$$

<br>

7. Calculates the `Molar Concentrations` for each Nephronal Unit starting at the Proximal Tubule

$$M⠀=⠀\frac{\text{Molar Flow Rates}}{\text{Volumetric Flow Rates}}$$
$$\text{Unit: }\color{grey}\left(\frac{\text{mmol}}{\text{L}}\right)$$

<br>

8. Calculates the `Mass Outflow Rates` after passing through the Collecting Duct

$$\dot m_j⠀=⠀\text{Molar Flow Rates}(\text{Collecting Duct})\text{ }\times\text{ }\text{Molecular Weight}\text{ }\times\text{ }10^{-3}$$
$$\text{Unit: }\color{grey}\left(\frac{\text{g}}{\text{min}}\right)$$

<br>

9. Plots Graphs
- $\text{mM}$ vs. Nephronal Unit
- $\frac{\text{mmol}}{\text{min}}$ vs. Nephronal Unit

12 plots total for the following conditions:
1. Healthy patient
2. CKD Stage 3b
3. Type II diabetes mellitus (early)
4. Type II diabetes mellitus (late)
5. Hypertension
6. A combination of 2, 4, 5

## Parametrization and Generalizability
1. Robust test cases - CKD Stage 3b, type II diabetes (early and late), hypertension, and a combination of CKD Stage 3b, late type II diabetes, and hypertension (as would typically occur in a CKD patient)
2. Pseudomodeling of pH modulation via bicarbonate accounting
3. Accounting for key constituents that play a role in CKD comorbidities (i.e. glucose for diabetes modeling, hyperkalemia/hyperchloremia/hypernatremia/etc.)

