## Model
$$\text{Renal Corpuscle}\longrightarrow\text{Proximal Tubule}\longrightarrow\text{Descending Limb}\longrightarrow\text{Ascending Limb}\longrightarrow\text{Distal Tubule}\longrightarrow\text{Collecting Duct}$$

<br>

## Conservation Equation
For Each Solute $s$ in 1 Nephron Unit:

$$\text{In }-\text{ Out }-{\color{green}\text{ Reabsorbed }}+{\color{red}\cancel{\text{ Secreted }}}~~=~~0$$

- *Assuming steady-state system, no reactions*
- *Assuming no secretion*
- $\color{green}\text{Reabsorbed}$ = *From filtrate into interstitial fluid*
- $\color{red}\text{Secreted}$ = *From bloodstream into filtrate*
<br>

To Calculate the Flow Rate per Unit, Rearrange the Conservation Equation:

$$\text{ Out}⠀=⠀\text{In }-{\color{green}\text{ Reabsorbed }}+{\color{red}\cancel{\text{ Secreted }}}$$

## Equation Form
$$\dot\psi_{reabs}⠀=⠀\dot\psi_{in}w_{reabs}$$
$$\dot\psi_{sec}⠀=⠀\dot\psi_{in}w_{sec}$$

$$\begin{array}{l}
\dot\psi_{out}&=&\dot\psi_{in}⠀-⠀\dot\psi_{reabs}⠀+⠀\cancel{\dot\psi_{sec}}\\
&=&\dot\psi_{in}⠀-⠀\dot\psi_{in}(w_{reabs})\\
&=&\dot\psi_{in}[1~-~w_{reabs}]
\end{array}$$


## Data
Mass Reabsorbption Fractions will be stored in a $6\times 9$ Matrix
- Each Row is a Nephronal Unit
- Each Column is a Selected Chemical Constituent

$$\text{reabs}\textunderscore\text{frac}()$$
$$\begin{bmatrix}
&⠀\text{Na}^+⠀~&⠀\text{Cl}^-⠀&\text{ Urea }&\text{Glucose}&⠀\text{K}^+⠀&\text{ HCO}_3^-&\text{ Mg}^{2+}&\text{ PO}_4^{3-}&\text{Creatinine}\\
\text{RP}_1&0    &0    &0    &0    &0    &0    &0    &0    &0\\
\text{PT}_2&0.65 &0.50 &0.50 &0.99 &0.50 &0.80 &0.20 &0.75 &sec\\
\text{DL}_3&0    &0    &\color{red}sec  &0    &\color{red}?    &0.15 &0    &0    &0\\
\text{AL}_4&0.25 &0.20 &0    &0    &0.20 &0    &0.65 &0    &0\\
\text{DT}_5&0.05 &0.05 &0    &0    &\color{red}?    &0    &0.05 &0.05 &0\\
\text{CD}_6&0.02 &0.03 &\color{red}?    &0    &\color{red}?    &1.00 &0    &1.00 &0\\
\end{bmatrix}$$

<br>

Initial Concentrations of Chemical Constituents in Filtrate

$$\begin{bmatrix}
\text{Na}^+&⠀\text{Cl}^-⠀&\text{ Urea }&\text{Glucose}&⠀\text{K}^+⠀&\text{ HCO}_3^-&\text{ Mg}^{2+}&\text{ PO}_4^{3-}&\text{Creatinine}\\
140 & 103 & 5 & 5 &\color{red}? & \color{red}? & \color{red}? &  \color{red}? & \color{red}?
\end{bmatrix}\frac{\text{mmol}}{\text{L}}$$

<br>

## Pseudocode
1. Initializes vectors for `Chemicals`, `Nephronal Units`, `Inlet Filtrate Concentrations`, and `Molar Flow Rates`
2. Initializes data matrix for `Reabsorption Fractions`
3. Initializes starting values at Renal Corpuscle: `Inlet Filtrate Concentrations`
4. Calculates the snGFR

$$\text{snGFR}⠀=⠀\frac{60}{1000}$$
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
