library(tidyverse)
library(lme4)
library(lmerTest)
library(sjPlot)
library(ggthemes)

# Load student
print('Loading student data...')
student_df = read.csv('outputs/student_beliefs.csv') %>%
  mutate_at(c('worker', 'teacher', 'problem'), factor) %>% # categorical vars
  rename(student = worker)

print(head(student_df))
str(student_df)

# Run regression
student_reg = lmer(belief_in_true ~ num_hint*teacher_rating + (1|problem) +
                     (1|student) + (1|teacher), data=student_df)
print(summary(student_reg))

# Plot random effects
re_plots = plot_model(student_reg, type='re')

# Get random effects of teacher
teacher_eff = ranef(student_reg) %>%
  .$teacher %>%
  rename('random_intercept' = '(Intercept)') %>%
  mutate(subject = as.numeric(rownames(.)))

# Load teacher model comparison results
model_df = read.csv('../2_behavioral/outputs/second_level_model_regressors.csv') %>%
  left_join(teacher_eff)

ggplot(model_df, aes(logBF, random_intercept)) +
  geom_point() +
  geom_smooth(method='lm') +
  xlab('Evidence for information-maximizing model') +
  ylab('Random effect of teacher on student performance') +
  theme_few()