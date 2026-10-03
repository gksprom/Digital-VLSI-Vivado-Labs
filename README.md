# VLSI Lab

VHDL solutions matched to the exercise statements supplied from the laboratory manual.

## Included exercises

| Exercise | Topic | Code |
| --- | --- | --- |
| A.2 | 3-to-8 binary decoder | Behavioral and dataflow implementations, each with a testbench |
| B.2 | 4-bit shift register with parallel load | Reference right-shift implementation and requested bidirectional solution with a testbench |
| B.3 | 3-bit counter | Requested up/down and programmable-modulo counters, each with a testbench |

Each exercise directory contains its own extracted statement PDF and compact Vivado project. Generated runs, caches, simulation output, and machine-specific files are intentionally excluded.

See [SOURCE_MAP.md](SOURCE_MAP.md) for the exact source-to-statement mapping.

## Opening the projects

Open the `.xpr` file inside the relevant `code` subdirectory with Vivado. Only authored sources and project metadata are retained; Vivado will regenerate caches and runs when needed.

## Notes

- Source code was copied without functional edits.
- The statements were extracted from `DVLSI_2014_Lab.pdf` so that each folder has a focused εκφώνηση.
- The original manual refers to Active-HDL/Leonardo Spectrum, while the matching code is stored as Vivado projects.
- No license has been assigned. Confirm permission and repository visibility before publishing course material.
