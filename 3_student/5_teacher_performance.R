library(tidyverse)
library(lme4)
library(lmerTest)
library(sjPlot)
library(arm)
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
re_plots = plot_model(student_reg, type='re', sort.est=TRUE)

# Get random effects of teacher
teacher_eff = ranef(student_reg) %>%
  .$teacher %>%
  rename('random_intercept' = '(Intercept)') %>%
  mutate(subject = as.numeric(rownames(.)),
         se = se.ranef(student_reg)$teacher)

# Get random effects of problem
problem_eff = ranef(student_reg) %>%
  .$problem %>%
  rename('random_intercept' = '(Intercept)') %>%
  mutate(problem = as.numeric(rownames(.)),
         se = se.ranef(student_reg)$problem)

# Plot random effects
ggplot(teacher_eff, aes(x = reorder(subject, -random_intercept), y = random_intercept)) +
  geom_bar(stat = "identity") +
  geom_errorbar(aes(ymin=random_intercept-se, ymax=random_intercept+se), width=0) +
  theme_few(base_size=18) +
  xlab('Teachers (reordered)') +
  ylab('Random intercepts') +
  theme(axis.ticks.x = element_blank(),
        axis.text.x = element_blank())
ggsave('plots/teacher_ranef.pdf', width=6.73, height=6.73/2)

ggplot(problem_eff, aes(x = reorder(problem, -random_intercept), y = random_intercept)) +
  geom_bar(stat = "identity") +
  geom_errorbar(aes(ymin=random_intercept-se, ymax=random_intercept+se), width=0) +
  theme_few(base_size=18) +
  xlab('Problems (reordered)') +
  ylab('Random intercepts') +
  theme(axis.ticks.x = element_blank(),
        axis.text.x = element_blank())

ggsave('plots/problem_ranef.pdf', width=6.73, height=6.73/2)


# Load teacher model comparison results
model_df = read.csv('../2_behavioral/outputs/second_level_model_regressors.csv') %>%
  left_join(teacher_eff)

ggplot(model_df, aes(logBF, random_intercept)) +
  geom_point() +
  geom_smooth(method='lm') +
  xlab('Evidence for information-maximizing model') +
  ylab('Random effect of teacher on student performance') +
  theme_few()
  
