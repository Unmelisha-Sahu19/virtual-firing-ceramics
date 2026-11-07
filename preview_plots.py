"""Optional: reproduces the MATLAB plots in Python (numpy + matplotlib) so the
results/ images can be made without MATLAB. Same data files, same formulas as main.m."""
import csv
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

M_kaol, M_H2O = 258.16, 18.015
loss_frac = 2 * M_H2O / M_kaol
T = np.arange(25, 1201, 5)
progress = 1 / (1 + np.exp(-(T - 575) / 25))

clays = list(csv.DictReader(open('data/clay_compositions.csv')))
lit = list(csv.DictReader(open('data/literature_tga.csv')))
th = list(csv.DictReader(open('data/thermo_data.csv')))[0]

plt.figure(figsize=(9, 4.5))
for c in clays:
    k = float(c['kaolinite_wt']); loss = k / 100 * loss_frac * 100
    plt.plot(T, 100 - loss * progress, lw=2, label=f"{c['clay']} ({k:.1f}% kaolinite)")
plt.axvline(573, ls='--', c='r'); plt.text(578, 100.3, 'Quartz α-β', color='r', fontsize=8)
plt.axvline(1000, ls='--', c='g'); plt.text(1005, 100.3, 'Mullite/spinel', color='g', fontsize=8)
plt.plot([float(l['temperature_C']) for l in lit], [float(l['mass_percent']) for l in lit],
         'ks', label='Literature (Cameroonian kaolin)')
plt.xlabel('Temperature (°C)'); plt.ylabel('Mass (%)')
plt.title('Simulated mass change during firing')
plt.legend(loc='lower left', fontsize=8); plt.grid(alpha=.3); plt.ylim(84, 101.5)
plt.tight_layout(); plt.savefig('results/mass_vs_temperature.png', dpi=150); plt.close()

dH = float(th['dH_kJ_per_mol']) * 1000; dS = float(th['dS_J_per_molK'])
TK = np.arange(300, 1201, 10); dG = (dH - TK * dS) / 1000; Teq = dH / dS
plt.figure(figsize=(9, 4.5))
plt.plot(TK - 273.15, dG, lw=2); plt.axhline(0, ls='--', c='k')
plt.plot(Teq - 273.15, 0, 'ro'); plt.text(Teq - 273.15 + 15, 5, f'ΔG = 0 at {Teq-273.15:.0f} °C')
plt.xlabel('Temperature (°C)'); plt.ylabel('ΔG (kJ/mol)')
plt.title('Kaolinite dehydroxylation: ΔG vs T')
plt.grid(alpha=.3); plt.tight_layout(); plt.savefig('results/deltaG_vs_temperature.png', dpi=150); plt.close()
