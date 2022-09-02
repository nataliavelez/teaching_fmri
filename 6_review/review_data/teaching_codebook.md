# Codebook: Teaching task
Natalia Vélez, August 2022

**subject:** Participant ID (one-indexed).

**run:** Index of the current run (one-indexed).

**block_idx:** Index of the current block, relative to the start of the run (zero-indexed: 0, 1, 2, 3).

**ex_idx:** Index of the current test trial (zero-indexed: 0, 1, 2).

**first_movement:** [row, column] coordinates of the first location where participants moved the cursor; used for debugging. By convention, [0,0] refers to the top left corner, and [5,5] to the bottom right corner.

**start:** [row, column] coordinates of the cursor location at the start of the block. By convention, [0,0] refers to the top left corner, and [5,5] to the bottom right corner.

**onset:** Time of start of response period, in seconds; t=0 refers to the start of the run.

**problem:** Index of the current multiple-choice question as it appears in `problems.json` (zero-indexed).

**order:** Order in which choice alternatives were shuffled; each of these letters corresponds to a key in the corresponding entry of `problems.json`.

**example:** [row, column] coordinates of the example selected by the teacher. By convention, [0,0] refers to the top left corner, and [5,5] to the bottom right corner.

**rating:** Participants' answer to the rating question ("Suppose students saw just these hints. How likely are they to get it right?") on a 5-point Likert scale (ranging from 1="No chance" to 5="Certainly").
