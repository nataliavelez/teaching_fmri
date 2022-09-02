# Codebook: Student task
Natalia Vélez, August 2022

**time_elapsed:** Time elapsed since participant loaded the experiment page (in ms).

**teacher:** Unique ID distinguishing the teacher. (If you look at the `subject` column in `teaching_behavior.csv`, this column is formatted as f'sub-{subject:02}')

**problem:** Index of the current multiple-choice question as it appears in `problems.json` (zero-indexed).

**num_trial:** Index of the current block, relative to the start of the task (zero-indexed: 0, 1, 2, ... 39).

**num_hint:** Index of the current test trial (zero-indexed: 0, 1, 2).

**bets:** Raw bet allocations. For analyses, these need to be (1) rescaled to sum to 1, and (2) sorted according to the order in which the hypotheses were presented (see `order`, below). For example, if the order for particular problem is B, D, A, C, then you can extract the bet placed on the correct answer by taking the third element of `bets`.

**bonus:** Total bonus given; proportional to the bet placed on the correct answer.

**worker:** Anonymized participant IDs.

**trial_order:** Counterbalanced order in which teachers were assigned to problems. The full details of these orders are contained in `Stimuli/all_trial_orders.json`. This file contains a list of lists of dictionaries, where each element describes the problem to be presented (`problem`), the teacher whose examples are being used (`teacher`), the order in which the hypothesis space is shuffled (`order`), and the state of the canvas on each trial (`states`).

**order:** Order in which hypotheses were presented

**bets_sorted:** Bet allocations sorted according to `order`

**belief_in_true:** Posterior belief in correct answer, after rescaling `bets_sorted` to sum to 1