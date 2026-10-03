# Source and matching map

| Exercise | Statement pages in source PDF | Selected Vivado projects | Match evidence | Confidence |
| --- | --- | --- | --- | --- |
| A.2 | PDF page 25 | `ex1` and `ex1_dataflow` | Entities implement a 3-to-8 decoder; both requested architectures are present | High |
| B.2 | PDF pages 36-38 | `rshift_reg3` and `ex_1_4bit_register` | Reference right-shift entity plus a 4-bit register with direction input and testbench | High |
| B.3 | PDF pages 38-43 | `updown_counter` and `modulo_counter` | Entity ports and behavior match the two numbered requested variants | High |

The source PDF is `DVLSI_2014_Lab.pdf`. Page 38 is intentionally present in both B.2 and B.3 because the B.2 request ends and B.3 begins on that page.

Generated Vivado directories (`.Xil`, runs, caches, hardware output, simulation output, generated IP, and user files) were not copied.
