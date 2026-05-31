import os
import glob

v_files = []
for root, _, files in os.walk("."):
    if ".git" in root or "verification" in root:
        continue
    for f in files:
        if f.endswith(".v") or f.endswith(".sv"):
            v_files.append(os.path.join(root, f))

# Sort to have common first if possible, though Yosys reads all at once
v_files.sort(key=lambda x: (0 if 'common' in x else 1, x))

tcl_content = "# Yosys synthesis script for SMVDU Titan-X\n\n"
tcl_content += "read_verilog -Icommon -sv \\\n"
for idx, f in enumerate(v_files):
    end_char = " \\" if idx < len(v_files) - 1 else ""
    tcl_content += f"    {f}{end_char}\n"

tcl_content += "\n# Elaborate design\n"
tcl_content += "hierarchy -top titan_x_top\n\n"
tcl_content += "# Run generic synthesis\n"
tcl_content += "synth -top titan_x_top\n\n"
tcl_content += "# Print statistics\n"
tcl_content += "stat\n"

with open("yosys_synth.tcl", "w") as f:
    f.write(tcl_content)

print("Generated yosys_synth.tcl")
