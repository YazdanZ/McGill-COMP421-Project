import pandas as pd
import matplotlib.pyplot as plt

export_path = "../exported/birth_months.csv"
save_path = "../report/images/pivot_chart.png"

plt.autoscale()
df = pd.read_csv(export_path, index_col=0, names=["month", "birth count"])
df.plot.bar(color="orchid")
plt.tight_layout()
plt.savefig(save_path, transparent=True)
