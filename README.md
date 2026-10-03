# Digital VLSI Vivado Labs

Vivado/VHDL laboratory work organized by exercise. Each current lab has a `statement/` directory containing the supplied Greek εκφώνηση and a `code/` directory containing the closest matching authored sources and compact Vivado project files.

## Current 2026 exercise set

| Directory | Exercise | Included code | Coverage |
| --- | --- | --- | --- |
| `lab-01-arithmetic-units` | Half adder, full adder, 4-bit parallel adder, BCD full adder, 4-digit BCD adder | Five Vivado projects with VHDL and testbenches | All five Part B tasks matched |
| `lab-02-pipelined-arithmetic` | Synchronous full adder, pipelined 4-bit adder, systolic multiplier | Three Vivado projects with testbenches | All three requested designs matched |
| `lab-02-bonus-led-blink` | Zybo LED blinker | VHDL and Zybo constraints | Matched |
| `lab-03-fir-filter` | 8-tap FIR | MAC, ROM, RAM, control, top level, constraints, and testbench | Matched |
| `lab-04-fir-axi-lite` | FIR on Zynq with AXI4-Lite | Vivado block design and packaged FIR IP | Hardware matched; no dedicated completed ARM application was found |
| `lab-05-debayering` | Static-size Debayering and AXI4-Stream integration | Completed Part A core/testbench plus the supplied Part B DMA/platform and software template | Part A matched; Part B is a template rather than a separately completed static AXI wrapper |
| `lab-06-bonus-runtime-reconfigurable-debayering` | Runtime-selectable 64–1024 Debayering | Vivado integration project and packaged AXI-Lite/AXI-Stream Debayer IP | Hardware matched |

## Supplemental legacy/manual exercises

`supplemental-legacy-manual/` contains the earlier manual exercises that were initially matched from screenshots:

- A.2: 3-to-8 decoder, behavioral and dataflow
- B.2: bidirectional 4-bit shift register
- B.3: up/down and programmable-modulo 3-bit counters

These are kept separate so they are not confused with the recently downloaded 2026 lab sequence.

## Opening the projects

Open the relevant `.xpr` file with Vivado. Generated runs, caches, simulation output, hardware output, and machine-specific files are excluded; Vivado will recreate them. Labs 4 and 6 also include their custom IP under `code/ip_repo/`; add that directory as an IP repository if Vivado does not resolve it automatically.

## Important notes

- Source code was copied without functional changes except one cleanup: an accidental terminal transcript appended after `end architecture;` was removed from the Lab 2 pipelined-adder VHDL copy.
- The statement PDFs are the recently downloaded files dated 3 October 2026. The supplemental exercise PDFs were extracted from `DVLSI_2014_Lab.pdf`.
- [SOURCE_MAP.md](SOURCE_MAP.md) records the exact source selection, evidence, and limitations.
- No license has been assigned. The repository is course material; confirm that public redistribution is permitted.
