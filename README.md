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
\dot\psi_{out}&=&\dot\psi_{in}⠀-⠀\dot\psi_{reabs}⠀+⠀\dot\psi_{sec}\\
&=&\dot\psi_{in}⠀-⠀\dot\psi_{in}(w_{reabs})⠀+⠀\dot\psi_{in}(w_{sec})\\
&=&\dot\psi_{in}[1~-~w_{reabs}~+~w_{sec}]
\end{array}$$


## Pseudocode  
GOAL: generate a 6x7 (haha) matrix displaying how much of each chemical is outputted from each nephron unit.
* Each row is one of the 6 units (RC, PT, DL, AL, DT, CD)
* Each column is one of the selected chemical constituents (H2O, Na+, Cl-, Urea, Glucose, K+, HCO₃-)

$$\begin{bmatrix}
\&H_2O&Na^+&Cl^-&\text{Urea}&\text{Glucose}&K^+&HCO_3^-\\
\text{RP}_1&0&0&0&0&0&0&0\\
\text{PT}_2&0&0&0&0&0&0&0\\
\text{DL}_3&0&0&0&0&0&0&0\\
\text{AL}_4&0&0&0&0&0&0&0\\
\text{DT}_5&0&0&0&0&0&0&0\\
\text{CD}_6&0&0&0&0&0&0&0\\
\end{bmatrix}$$


1. Allocate vectors for the units and chemicals
2. Initialize starting values (healthy GFR, secreted concentrations of each solute + water into Bowman's capsule)
3. Allocate a matrix of the reabsorption of each chemical constituent in each unit (6x7)
4. Allocate a matrix of the secretion of each chemical constituent in each unit (6x7) - should generally be pretty small/0
5. Preallocate 6x7 matrix of zeroes to hold results
6. Loop through vector of units to calcualte solute flows
7. Add headers, save as .csv/.xlsx/idk whatever we want
8. Generate line plot of pseudotime (passage through each unit) vs. solute flow rate, with one line per constituent



