# Student task analyses

Contents:

_Main analyses_
* `1_counterbalance_student_assignments.ipynb`: Assign teachers and problems to students. This script was run _before_ data collection.
* `2_check_data.ipynb`: Check that participants were appropriately assigned to teachers and problems, and check participants' overall performance.
* `3_performance.ipynb`: Process participants' responses and plot participants' beliefs as a function of (a) time and (b) teacher ratings
* `4_teacher_performance.Rmd`: Key analysis: Do teachers' ratings align with students' actual performance?
* `5_student_glm_events.ipynb`: Prepare parametric regressors derived from students' average responses (GLM 2)

_Quality checks_
* `QA_1_time_model_comparison.Rmd`: Check: How well are teacher ratings and human learners' self-reported beliefs explained by a control model that merely tracks the number of examples presented?
* `QA_2_time_model.ipynb`: Plot the results of QA 1 (used in supplementary figures)