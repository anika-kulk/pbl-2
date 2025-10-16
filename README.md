## Model
Will make a new diagram

## Key Mass Conservation Equation
For Each Solute $s$ in 1 Nephron Unit:

$$\text{In }-\text{ Out }-{\color{green}\text{ Reabsorbed }}+{\color{red}\cancel{\text{ Secreted }}}~~=~~0$$

- *Assuming steady-state system, no reactions*  
- $\color{green}\text{Reabsorbed}$ = *From filtrate into interstitial fluid*
- $\color{red}\text{Secreted}$ = *From bloodstream into filtrate*
<br>

To Calculate the Flow Rate per Unit, Rearrange the Conservation Equation:

$$\text{ Out}⠀=⠀\text{In }-{\color{green}\text{ Reabsorbed }}+{\color{red}\cancel{\text{ Secreted }}}$$

## Key Calculations
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
\text{RP}_1&0    &0    &     &0    &0    &0    &0    &0    &0\\
\text{PT}_2&0.65 &0.50 &0.50 &0.99 &0.50 &0.80 &0.20 &0.75 &sec\\
\text{DL}_3&0    &0    &\color{red}sec  &0    &?    &0.15 &0    &0    &0\\
\text{AL}_4&0.25 &0.20 &0    &0    &0.20 &0    &0.65 &0    &0\\
\text{DT}_5&0.05 &0.05 &0    &0    &?    &0    &0.05 &0.05 &0\\
\text{CD}_6&0.02 &0.03 &?    &0    &?    &1.00 &0    &1.00 &0\\
\end{bmatrix}$$


## Pseudocode
1. Allocate vectors for the units and chemicals
2. Initialize starting values (healthy GFR, secreted concentrations of each solute + water into Bowman's capsule)
3. Allocate a matrix of the reabsorption of each chemical constituent in each unit (6x7)
4. Allocate a matrix of the secretion of each chemical constituent in each unit (6x7) - should generally be pretty small/0
5. Preallocate 6x7 matrix of zeroes to hold results
6. Loop through vector of units to calcualte solute flows
7. Add headers, save as .csv/.xlsx/idk whatever we want
8. Generate line plot of pseudotime (passage through each unit) vs. solute flow rate, with one line per constituent



