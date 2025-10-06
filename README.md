### Key Mass Conservation Equation  
For each solute s in 1 nephron unit, IN - OUT - REABSORBED + SECRETED = 0  

*** *assuming steady-state, no reactions*  
*** *where reabsorbed = from filtrate into interstitial fluid, secreted = from bloodstream into filtrate*

To calculate the flow rate per unit, rearrange conservation equation: OUT = IN - REABSORBED + SECRETED

### Key Calculations  
Ψ <sub> reabs </sub> = w <sub> reabs </sub> * Ψ <sub> in </sub>  
Ψ <sub> sec </sub> = w <sub> sec </sub> * Ψ <sub> in </sub>  

Ψ <sub> out </sub> = Ψ <sub> in </sub> - Ψ <sub> reabs </sub> + Ψ <sub> sec </sub>  
= Ψ <sub> in </sub> - w <sub> reabs </sub> * Ψ <sub> in </sub> + w <sub> sec </sub> * Ψ <sub> in </sub>  
= Ψ <sub> in </sub> [ 1 - w <sub> reabs </sub> + w <sub> sec </sub> ]

### Pseudocode  
GOAL: generate a 6x7 (haha) matrix displaying how much of each chemical is outputted from each nephron unit.
* Each row is one of the 6 units (RC, PT, DL, AL, DT, CD)
* Each column is one of the selected chemical constituents (H2O, Na+, Cl-, Urea, Glucose, K+, HCO₃-)

1. Allocate vectors for the units and chemicals
2. Initialize starting values (healthy GFR, secreted concentrations of each solute + water into Bowman's capsule)
3. Allocate a matrix of the reabsorption of each chemical constituent in each unit (6x7)
4. Allocate a matrix of the secretion of each chemical constituent in each unit (6x7) - should generally be pretty small/0
5. Preallocate 6x7 matrix of zeroes to hold results
6. Loop through vector of units to calcualte solute flows
7. Add headers, save as .csv/.xlsx/idk whatever we want
8. Generate line plot of pseudotime (passage through each unit) vs. solute flow rate, with one line per constituent



