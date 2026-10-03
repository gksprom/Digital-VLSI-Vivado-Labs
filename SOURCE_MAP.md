# Source and matching map

## Current labs

| Lab | Statement source | Selected source | Match evidence | Confidence / limitation |
| --- | --- | --- | --- | --- |
| 1 | `dvlsi_2026_lab1_PartB (4).pdf` | `PROJECTS/ΕΧ1/erg1_1_half_adder` through `erg1_5_4bcd_parallel_adder` | Project names, VHDL entities, and testbenches correspond to the five numbered arithmetic-unit tasks | High |
| 2 | `dvlsi_2026_ex2.pdf` | `PROJECTS/EX2/synchronous_adder`, `pipeline_full_adder`, and `synchronous_mult` | Interfaces and hierarchy match the synchronous full adder, pipelined 4-bit parallel adder, and systolic multiplier | High; the copied pipelined-adder file had a non-VHDL terminal transcript removed after its valid final statement |
| 2 bonus | `dvlsi_ex2_extra_led_blink.pdf` | `Downloads/DVLSI_ex2_led_blink` | `blink_led.vhd` and Zybo constraints implement the requested LED blinker | High |
| 3 | `dvlsi2026_lab3.pdf` | `PROJECTS/EX3/fir_filter` | Contains the requested MAC, coefficient ROM, sample RAM, control unit, top level, constraints, and testbench | High |
| 4 | `dvlsi_fir_zybo_axilite (1).pdf` | `PROJECTS/EX4` and `PROJECTS/ip_repo/fir_ip_1_0` | Zynq block design plus packaged AXI4-Lite FIR IP containing the Lab 3 FIR hierarchy | High for hardware; no dedicated completed ARM/Vitis application was found in the matching project tree |
| 5 | `dvlsi_lab5 (2).pdf` | `PROJECTS/DEBAYER_FINAL` and `PROJECTS/dvlsi_lab6` | Static generic-sized, pipelined Debayer core and testbench match Part A; the DMA/Vitis material matches the Part B integration framework | High for Part A; Part B code present is the supplied platform/software template, not a separately completed static Debayer AXI-Stream IP |
| 6 bonus | `DVLSI_DEBAYERING_BONUS (1).pdf` | `PROJECTS/bonus_lab_2` and `PROJECTS/ip_repo/debayer_ip_1_0` | The core exposes `image_dim`/`image_dim_vld`, allocates for a maximum of 1024, gates ready until configured, and is packaged with AXI-Lite plus AXI-Stream interfaces | High for the hardware/IP implementation |

## Supplemental legacy/manual exercises

| Exercise | Statement pages in source PDF | Selected Vivado projects | Match evidence | Confidence |
| --- | --- | --- | --- | --- |
| A.2 | PDF page 25 | `ex1` and `ex1_dataflow` | Entities implement a 3-to-8 decoder; both requested architectures are present | High |
| B.2 | PDF pages 36–38 | `rshift_reg3` and `ex_1_4bit_register` | Reference right-shift entity plus a 4-bit register with direction input and testbench | High |
| B.3 | PDF pages 38–43 | `updown_counter` and `modulo_counter` | Entity ports and behavior match the two numbered requested variants | High |

The supplemental source PDF is `DVLSI_2014_Lab.pdf`. Page 38 is intentionally present in both B.2 and B.3 because the B.2 request ends and B.3 begins on that page.

Generated Vivado directories (`.Xil`, runs, caches, hardware output, simulation output, generated IP, and user files) were not copied.
