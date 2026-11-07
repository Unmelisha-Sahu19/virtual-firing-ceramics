# Virtual Firing of Ceramic Raw Materials (MATLAB)

A simulation-only project on how kaolinite clay loses structural water during firing.
All inputs are taken from published research papers and thermochemical data. No lab work was done.

## About this project
When clay is fired, kaolinite loses about 13.96 wt% of its weight as structural water between 450 and 700 C (dehydroxylation).
This project simulates that mass loss in MATLAB for clays with different kaolinite content, and uses
dG = dH - T*dS to check when the reaction becomes thermodynamically possible.

## Key points
- Models TGA-style mass vs temperature curves for three clays (17.27, 72.41 and 100 wt% kaolinite)
- Calculates the theoretical mass loss of kaolinite (13.96 %)
- Plots dG vs temperature and finds the dG = 0 temperature (about 204 C)
- Compares the simulated mass loss with a literature value (about 12.5 %)
- Explains why thermodynamics (about 204 C) and the real range (450-700 C) differ: kinetics

## How to run
1. Download or clone this repository.
2. Open MATLAB (R2018b or newer) and set the Current Folder to this repository.
3. Open `main.m` and press Run.
4. Mass-loss values print in the Command Window. Plots are saved in `results/`.
5. To try another clay, add a row in `data/clay_compositions.csv` with its kaolinite wt% and source.

## Results
Plots were generated with `preview_plots.py` (Python, same data and formulas as `main.m`). Running `main.m` in MATLAB gives the same curves.

![Mass vs temperature](results/mass_vs_temperature.png)

*Figure 1. Simulated mass change during firing. Higher kaolinite content gives a larger mass loss, with most of it between 450 and 700 C.*

![Delta G vs temperature](results/deltaG_vs_temperature.png)

*Figure 2. Dehydroxylation dG vs temperature. dG becomes negative above about 204 C (standard state).*

## Data sources
| Input | Value | Source |
|---|---|---|
| Kaolinite water content | 13.96 wt% | Fotsop et al., RSC Advances 2025 (d5ra05149e) |
| Dehydroxylation range | 450-700 C | Onal et al., J Therm Anal Calorim; Fotsop et al. 2025 |
| Reaction dH | about 180 kJ/mol (range 159-201) | Nicholson and Fulrath, UCRL-19025 |
| Kaolinite entropy | 200.9 J/mol.K | Robie and Hemingway, Clays Clay Miner. 39 (1991) |
| Reaction dS | 377.6 J/mol.K (assumption) | 2 x S(H2O gas) = 188.8 J/mol.K (NIST-JANAF) |
| Clay kaolinite contents | 72.41 and 17.27 wt% | XRD table, Benin Formation clays (dergipark.org.tr, article 4488118) |
| Literature mass loss | about 12.5 % | Fotsop et al., RSC Advances 2025 |

## Assumptions and limitations
- The mass-loss S-curve (centred at 575 C) is a simple model, not a kinetic fit.
- Only kaolinite loses mass in the model. Illite, hematite and other phases are ignored.
- dS assumes the solid-phase entropy change is about zero, so the water-vapour term dominates.
- dG = 0 at about 204 C is far below the real 450-700 C range because kinetics (activation energy,
  heating rate, particle size) controls when the reaction actually happens.

## Author
Unmelisha Sahu, Ceramic Engineering, NIT Rourkela

