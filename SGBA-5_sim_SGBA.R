# load libraries and simulated data ---------------------------------------

library(tidyverse)
library(ggpubr)
library(extrafont)  # for exporting plots with Times New Roman Font

# set seed for reproducibility
set.seed(42)

# load data set (from RDS if using previous script to simulate the data)
sim_data <- read_rds(file = '[SIMULATEDDATASET].RDS')  # replace [SIMULATEDDATASET] with location of data set


# store plot theme preset -------------------------------------------------

# store axis options for gender variable plots
gender_plot_theme <-   
  theme_classic() +
  theme(
    text = element_text(family = 'serif'),
    legend.position = 'none',
    axis.ticks.x = element_blank(),
    axis.text.x = element_blank()
  )

# default density plots and scale
plot_dens_2D <- function(data, x, y){
  plot <- ggplot(data = data, aes(x = x, y = y)) + 
    geom_density_2d_filled(aes(fill = after_stat(level)),
                           bins = 9, contour_var = 'ndensity') +
    scale_fill_brewer(palette = 16, direction = 1, 
                      labels = c('Low', '', '', '','','','','', 'High')) +
    guides(fill = guide_legend(title = 'Density of Occurences', 
                               direction = 'horizontal', nrow = 1, 
                               label.position = 'bottom'))
  plot
}


# uni-variate plots --------------------------------------------------------

# biological sex bar plot
sex_bar <- ggplot(sim_data, aes(x = bio_sex)) +
  geom_bar(aes(fill = bio_sex), show.legend = F) + 
  labs(title = 'Barplot of Simulated\nBiological Sex (n=30)') +
  ylab('Count') + xlab('Biological Sex') +
  theme_classic() +
  theme(text = element_text(family = 'serif'))
sex_bar  # view plot

# gender identity density plot
gi_dens <- ggplot(sim_data, aes(x = gen_id)) +
  geom_density(alpha=.5, fill = 'forestgreen', colour = 'black') +
  labs(title = 'Densityplot of Simulated\nGender Identity (n=30)') +
  ylab('Density') + xlab('Feminine - Masculine Continuum') +
  gender_plot_theme  
gi_dens  # view plot

# gender role density plot
grol_dens <- ggplot(sim_data, aes(x = gen_role)) +
  geom_density(alpha=.5, fill = 'purple2', colour = 'black') +
  labs(title = 'Densityplot of Simulated\nGender Role (n=30)') +
  ylab('Density') + xlab('Feminine - Masculine Continuum') +
  gender_plot_theme  
grol_dens  # view plot


# SGBA positive examples --------------------------------------------------

## continuous variable ----------------------------------------------------

### by biological sex example ---------------------------------------------

# density plot
neg_cont_sex_dens <- ggplot(sim_data, aes(x = outcome_num_neg_sex, fill = bio_sex)) + 
  geom_density(alpha = 0.7) +
  scale_fill_manual(values = c('forestgreen', 'skyblue')) +
  labs(title = 'Density Plot of Simulated Continuous Variable by Biological Sex (n=30)') +
  xlab('Continuous Outcome') + 
  ylab('Response Density') +
  theme_classic() +
  theme(legend.position = 'bottom', text = element_text(family = 'serif'))
neg_cont_sex_dens  # view plot

# summary stats
neg_cont_sex_sum <- sim_data %>% group_by(bio_sex) %>% 
  summarise(
    n = n(), 
    `mean continuous` = round(mean(outcome_num_neg_sex),1),
    `SD continuous` = round(sd(outcome_num_neg_sex),2),
    `median continuous` = round(median(outcome_num_neg_sex),0),
    `IQR continuous` = round(IQR(outcome_num_neg_sex),)
  ) %>% 
  rename(`biological sex` = bio_sex) 
neg_cont_sex_sum   # view stats

# t test
con_sex_ttest <- t.test(outcome_num_neg_sex ~ bio_sex, data = sim_data)
con_sex_ttest   # view test results


### by gender identity example -------------------------------------------

# scatter plot
pos_cont_gi_scatter <- ggplot(
  data = sim_data, aes(x = gen_id, y = outcome_num_pos_gid)
  ) + 
  geom_jitter(size = 3, colour = 'forestgreen') + 
  # labs(title = 'Scatterplot of Simulated Numerical Outcome\n& Gender Identity (n=30)') +
  ylab('Continuous Outcome') +
  xlab('Feminine - Masculine Continuum') +
  gender_plot_theme
pos_cont_gi_scatter  # view plot

# 2D density plot
pos_cont_gi_dens2d <- plot_dens_2D(
  sim_data, gen_id, outcome_num_pos_gid
  ) +
  #  labs(title = '2D Density of Simulated Numerical\nOutcome & Gender Identity (n=30)') +
  ylab('Continuous Outcome') +
  xlab('Feminine - Masculine Continuum') +
  gender_plot_theme
pos_cont_gi_dens2d  # view plot

# Pearson's r
pos_cont_gi_cor <- cor.test(
  sim_data$outcome_num_pos_gid, 
  sim_data$gen_id, 
  method = 'pearson'
  )
pos_cont_gi_cor   # view test results


### by gender role example -----------------------------------------------

# scatter plot
pos_cont_role_scatter <- ggplot(
  sim_data, aes(x = gen_role, y = outcome_num_pos_grol)
  ) + 
  geom_jitter(size = 3, colour = 'forestgreen') + 
  #  labs(title = 'Scatterplot of Simulated Numerical Outcome\n& Gender Role') +
  ylab('Simuluated Continuous Outcome') +
  xlab('Feminine - Masculine Continuum') +
  gender_plot_theme
pos_cont_role_scatter  # view plot

# 2D density plot
pos_cont_role_dens2d <- plot_dens_2D(
  sim_data, gen_role, outcome_num_pos_grol
  ) +
  #  labs(title = '2D Density of Simulated Numerical\nOutcome & Gender Role (n=30)') +
  ylab('Simuluated Continuous Outcome') +
  xlab('Feminine - Masculine Continuum') +
  gender_plot_theme
pos_cont_role_dens2d  # view plot

# Pearson's r
pos_cont_grol_cor <- cor.test(
  sim_data$outcome_num_pos_grol,
  sim_data$gen_role,
  method='pearson'
  )
pos_cont_grol_cor  # view test results


## ordinal variable -------------------------------------------------------

### by biological sex example ---------------------------------------------

# bar plot
pos_ord_sex_bar <- ggplot(
  sim_data, aes(x = outcome_ord_pos_sex, fill = bio_sex)
  ) +
  geom_bar() + 
  facet_wrap(~ bio_sex) +
  scale_fill_manual(values = c('forestgreen', 'skyblue')) +
  labs(title = 'Bar Plot of Simulated Likert Outcome and Sex Assigned\nat Birth(n=30)') +
  xlab('Simulated Likert Scale Variable') +
  theme(panel.grid = element_blank(),panel.background = element_blank(), 
        legend.position = 'none', text = element_text(family = 'serif'))
pos_ord_sex_bar  # view plot

# summary stats
pos_ord_sex_sum <- sim_data %>% group_by(bio_sex) %>% 
  summarise(
    n = n(), 
    `median Likert` = round(median(as.numeric(outcome_ord_pos_sex)),0),
    `IQR Likert` = round(IQR(as.numeric(outcome_ord_pos_sex)),)
  ) %>% 
  rename(`biological sex` = bio_sex) 
pos_ord_sex_sum   # view stats

# chi-square test
pos_ord_sex_chi <- chisq.test(
  x = sim_data$outcome_ord_pos_sex, 
  y = sim_data$bio_sex
)
pos_ord_sex_chi   # view test results


### by gender identity example ---------------------------------------------

# jitter
pos_ord_gi_jit <- ggplot(
  sim_data, aes(x = gen_id, y = outcome_ord_pos_gid)
  ) +
  geom_jitter(
    aes(colour = outcome_ord_pos_gid, alpha = 0.7), size = 4, height = 0.1
    ) +
  # labs(title = 'Scatterplot of Simulated Likert Outcome\n& Gender Identity (n=30)') +
  xlab('Feminine - Masculine Continuum') +
  ylab('Simuluated Likert Outcome') +
  geom_hline(
    yintercept = c(1.5, 2.5, 3.5, 4.5, 5.5, 6.5),
    linetype='dashed', colour='grey'
    ) +
  gender_plot_theme
pos_ord_gi_jit  # view plot

# 2D Density
pos_ord_gi_den <- plot_dens_2D(
  sim_data, gen_id, as.numeric(outcome_ord_pos_gid)
  ) +
  scale_y_continuous(
    breaks = c(1,2,3,4,5,6,7), labels = c(1,2,3,4,5,6,7), limits = c(1,7)
    ) +
  # labs(title = '2D Density of Simulated Likert Outcome\n& Gender Identity (n=30)') +
  xlab('Feminine - Masculine Continuum') +
  ylab('Simuluated Likert Outcome') + 
  geom_hline(yintercept = c(1.5, 2.5, 3.5, 4.5, 5.5, 6.5)) +
  gender_plot_theme
pos_ord_gi_den  # view plot

## Pearson's r
pos_ord_gi_cor <- cor.test(
  as.numeric(sim_data$outcome_ord_pos_gid), 
  sim_data$gen_id, 
  method = 'pearson'
  )
pos_ord_gi_cor   # view test results


### by gender role example -------------------------------------------------

# jitter
pos_ord_gr_jit <- ggplot(
  sim_data, aes(x = gen_role, y = outcome_ord_pos_grol)
  ) + 
  geom_jitter(
    aes(colour = outcome_ord_pos_grol, alpha = 0.7), size = 4, height = 0.1
    ) +
  # labs(title = 'Scatterplot of Simulated Likert Outcome\n& Gender Role (n=30)') +
  xlab('Feminine - Masculine Continuum') +
  ylab('Simuluated Likert Outcome') +
  geom_hline(
    yintercept = c(1.5, 2.5, 3.5, 4.5, 5.5, 6.5), 
    linetype='dashed', colour='grey'
    ) +
  gender_plot_theme
pos_ord_gr_jit  # view plot

# 2D Density
pos_ord_gr_den <- plot_dens_2D(
  sim_data, gen_role, as.numeric(outcome_ord_pos_grol)
  ) +
  scale_y_continuous(
    breaks = c(1,2,3,4,5,6,7), labels = c(1,2,3,4,5,6,7), limits = c(1,7)
    ) +
  # labs(title = '2D Density of Simulated Likert Outcome\n& Gender Role (n=30)') +
  xlab('Feminine - Masculine Continuum') +
  ylab('Simuluated Likert Outcome') + 
  geom_hline(yintercept = c(1.5, 2.5, 3.5, 4.5, 5.5, 6.5)) +
  gender_plot_theme
pos_ord_gr_den  # view plot        

# Pearson's r
pos_ord_gr_cor <- cor.test(
  as.numeric(sim_data$outcome_ord_pos_grol), 
  sim_data$gen_role, 
  method='pearson'
  )
pos_ord_gr_cor   # view test results


## binary variable -------------------------------------------------------

### by biological sex example ---------------------------------------------

# bar plot
pos_binary_sex_bar <- ggplot(
  sim_data, aes(x = outcome_bin_pos_sex, fill = bio_sex)
  ) +
  geom_bar() + 
  facet_wrap(~ bio_sex) +
  scale_fill_manual(values = c('forestgreen', 'skyblue')) +
  labs(title = 'Bar Plot of Simulated Binary Outcome and Sex Assigned\nat Birth(n=30)') +
  xlab('Simulated Binary Variable') +
  theme(panel.grid = element_blank(),panel.background = element_blank(), 
        legend.position = 'none', text = element_text(family = 'serif'))
pos_binary_sex_bar  # view plot

# frequency table
pos_binary_sex_freq <- table(sim_data$outcome_bin_pos_sex, sim_data$bio_sex)
pos_binary_sex_freq   # view stats

# chi-square test
pos_binary_sex_chi <- chisq.test(sim_data$outcome_bin_pos_sex,sim_data$bio_sex)
pos_binary_sex_chi   # view test results


### by gender identity example ---------------------------------------------

# bar plot
pos_binary_gi_dens <- ggplot(
  sim_data, aes(x = gen_id, fill = outcome_bin_pos_gid)
  ) +
  geom_density(alpha = 0.7) + 
  scale_fill_manual(values = c('forestgreen', 'skyblue')) +
  labs(title = 'Density Plots of Simulated Binary Outcome and Gender Identity\n(n=30)') +
  xlab('Feminine - Masculine Continuum') +
  theme_classic() +
  theme(
    text = element_text(family = 'serif'),
    axis.ticks.x = element_blank(),
    axis.text.x = element_blank()
  )
pos_binary_gi_dens  # view plot

# t test
pos_binary_gi_ttest <- t.test(gen_id ~ outcome_bin_pos_gid, data = sim_data)
pos_binary_gi_ttest   # view test results


### by gender roles example ------------------------------------------------

# bar plot
pos_binary_grole_dens <- ggplot(
  sim_data, aes(x = gen_role, fill = outcome_bin_pos_grol)
  ) +
  geom_density(alpha = 0.7) + 
  # facet_wrap(~ sim_binary) +
  scale_fill_manual(values = c('forestgreen', 'skyblue')) +
  labs(title = 'Density Plots of Simulated Binary Outcome and Gender Roles\n(n=30)') +
  xlab('Feminine - Masculine Continuum') +
  theme_classic() +
  theme(
    text = element_text(family = 'serif'),
    axis.ticks.x = element_blank(),
    axis.text.x = element_blank()
  )
pos_binary_grole_dens  # view plot

# t test
pos_binary_grole_ttest <- t.test(gen_role ~ outcome_bin_pos_grol, data = sim_data)
pos_binary_grole_ttest   # view test results


# SGBA negative examples --------------------------------------------------

## continuous variable ----------------------------------------------------

### by biological sex example ---------------------------------------------

# density plot
neg_cont_sex_dens <- ggplot(sim_data, aes(x = outcome_num_neg, fill = bio_sex)) + 
  geom_density(alpha = 0.7) +
  scale_fill_manual(values = c('forestgreen', 'skyblue')) +
  labs(title = 'Density Plot of Simulated Continuous Variable by Biological Sex (n=30)') +
  xlab('Continuous Outcome') + 
  ylab('Response Density') +
  theme_classic() +
  theme(legend.position = 'bottom', text = element_text(family = 'serif'))
neg_cont_sex_dens  # view plot

# summary stats
neg_cont_sex_sum <- sim_data %>% group_by(bio_sex) %>% 
  summarise(
    n = n(), 
    `mean continuous` = round(mean(outcome_num_neg),1),
    `SD continuous` = round(sd(outcome_num_neg),2),
    `median continuous` = round(median(outcome_num_neg),0),
    `IQR continuous` = round(IQR(outcome_num_neg),)
  ) %>% 
  rename(`biological sex` = bio_sex) 
neg_cont_sex_sum   # view stats

# t test
con_sex_ttest <- t.test(outcome_num_neg ~ bio_sex, data = sim_data)
con_sex_ttest   # view test results


### by gender identity example -------------------------------------------

# scatter plot
neg_cont_gi_scatter <- ggplot(
  data = sim_data, aes(x = gen_id, y = outcome_num_neg)
) + 
  geom_jitter(size = 3, colour = 'forestgreen') + 
  # labs(title = 'Scatterplot of Simulated Numerical Outcome\n& Gender Identity (n=30)') +
  ylab('Continuous Outcome') +
  xlab('Feminine - Masculine Continuum') +
  gender_plot_theme
neg_cont_gi_scatter  # view plot

# 2D density plot
neg_cont_gi_dens2d <- plot_dens_2D(
  sim_data, gen_id, outcome_num_neg
) +
  #  labs(title = '2D Density of Simulated Numerical\nOutcome & Gender Identity (n=30)') +
  ylab('Continuous Outcome') +
  xlab('Feminine - Masculine Continuum') +
  gender_plot_theme
neg_cont_gi_dens2d  # view plot

# Pearson's r
neg_cont_gi_cor <- cor.test(
  sim_data$outcome_num_neg, 
  sim_data$gen_id, 
  method = 'pearson'
)
neg_cont_gi_cor   # view test results


### by gender role example -----------------------------------------------

# scatter plot
neg_cont_role_scatter <- ggplot(
  sim_data, aes(x = gen_role, y = outcome_num_neg)
) + 
  geom_jitter(size = 3, colour = 'forestgreen') + 
  #  labs(title = 'Scatterplot of Simulated Numerical Outcome\n& Gender Role') +
  ylab('Simuluated Continuous Outcome') +
  xlab('Feminine - Masculine Continuum') +
  gender_plot_theme
neg_cont_role_scatter  # view plot

# 2D density plot
neg_cont_role_dens2d <- plot_dens_2D(
  sim_data, gen_role, outcome_num_neg
) +
  #  labs(title = '2D Density of Simulated Numerical\nOutcome & Gender Role (n=30)') +
  ylab('Simuluated Continuous Outcome') +
  xlab('Feminine - Masculine Continuum') +
  gender_plot_theme
neg_cont_role_dens2d  # view plot

# Pearson's r
neg_cont_grol_cor <- cor.test(
  sim_data$outcome_num_neg,
  sim_data$gen_role,
  method='pearson'
)
neg_cont_grol_cor  # view test results


## ordinal variable -------------------------------------------------------

### by biological sex example ---------------------------------------------

# bar plot
neg_ord_sex_bar <- ggplot(
  sim_data, aes(x = outcome_ord_neg, fill = bio_sex)
) +
  geom_bar() + 
  facet_wrap(~ bio_sex) +
  scale_fill_manual(values = c('forestgreen', 'skyblue')) +
  labs(title = 'Bar Plot of Simulated Likert Outcome and Sex Assigned\nat Birth(n=30)') +
  xlab('Simulated Likert Scale Variable') +
  theme(panel.grid = element_blank(),panel.background = element_blank(), 
        legend.position = 'none', text = element_text(family = 'serif'))
neg_ord_sex_bar  # view plot

# summary stats
neg_ord_sex_sum <- sim_data %>% group_by(bio_sex) %>% 
  summarise(
    n = n(), 
    `median Likert` = round(median(as.numeric(outcome_ord_neg)),0),
    `IQR Likert` = round(IQR(as.numeric(outcome_ord_neg)),)
  ) %>% 
  rename(`biological sex` = bio_sex) 
neg_ord_sex_sum   # view stats

# chi-square test
neg_ord_sex_chi <- chisq.test(
  x = sim_data$outcome_ord_neg, 
  y = sim_data$bio_sex
)
neg_ord_sex_chi   # view test results


### by gender identity example ---------------------------------------------

# jitter
neg_ord_gi_jit <- ggplot(
  sim_data, aes(x = gen_id, y = outcome_ord_neg)
) +
  geom_jitter(
    aes(colour = outcome_ord_neg, alpha = 0.7), size = 4, height = 0.1
  ) +
  # labs(title = 'Scatterplot of Simulated Likert Outcome\n& Gender Identity (n=30)') +
  xlab('Feminine - Masculine Continuum') +
  ylab('Simuluated Likert Outcome') +
  geom_hline(
    yintercept = c(1.5, 2.5, 3.5, 4.5, 5.5, 6.5),
    linetype='dashed', colour='grey'
  ) +
  gender_plot_theme
neg_ord_gi_jit  # view plot

# 2D Density
neg_ord_gi_den <- plot_dens_2D(
  sim_data, gen_id, as.numeric(outcome_ord_neg)
) +
  scale_y_continuous(
    breaks = c(1,2,3,4,5,6,7), labels = c(1,2,3,4,5,6,7), limits = c(1,7)
  ) +
  # labs(title = '2D Density of Simulated Likert Outcome\n& Gender Identity (n=30)') +
  xlab('Feminine - Masculine Continuum') +
  ylab('Simuluated Likert Outcome') + 
  geom_hline(yintercept = c(1.5, 2.5, 3.5, 4.5, 5.5, 6.5)) +
  gender_plot_theme
neg_ord_gi_den  # view plot

## Pearson's r
neg_ord_gi_cor <- cor.test(
  as.numeric(sim_data$outcome_ord_neg), 
  sim_data$gen_id, 
  method = 'pearson'
)
neg_ord_gi_cor   # view test results


### by gender role example -------------------------------------------------

# jitter
neg_ord_gr_jit <- ggplot(
  sim_data, aes(x = gen_role, y = outcome_ord_neg)
) + 
  geom_jitter(
    aes(colour = outcome_ord_neg, alpha = 0.7), size = 4, height = 0.1
  ) +
  # labs(title = 'Scatterplot of Simulated Likert Outcome\n& Gender Role (n=30)') +
  xlab('Feminine - Masculine Continuum') +
  ylab('Simuluated Likert Outcome') +
  geom_hline(
    yintercept = c(1.5, 2.5, 3.5, 4.5, 5.5, 6.5), 
    linetype='dashed', colour='grey'
  ) +
  gender_plot_theme
neg_ord_gr_jit  # view plot

# 2D Density
neg_ord_gr_den <- plot_dens_2D(
  sim_data, gen_role, as.numeric(outcome_ord_neg)
) +
  scale_y_continuous(
    breaks = c(1,2,3,4,5,6,7), labels = c(1,2,3,4,5,6,7), limits = c(1,7)
  ) +
  # labs(title = '2D Density of Simulated Likert Outcome\n& Gender Role (n=30)') +
  xlab('Feminine - Masculine Continuum') +
  ylab('Simuluated Likert Outcome') + 
  geom_hline(yintercept = c(1.5, 2.5, 3.5, 4.5, 5.5, 6.5)) +
  gender_plot_theme
neg_ord_gr_den  # view plot        

# Pearson's r
neg_ord_gr_cor <- cor.test(
  as.numeric(sim_data$outcome_ord_neg), 
  sim_data$gen_role, 
  method='pearson'
)
neg_ord_gr_cor   # view test results


## binary variable -------------------------------------------------------

### by biological sex example ---------------------------------------------

# bar plot
neg_binary_sex_bar <- ggplot(
  sim_data, aes(x = outcome_bin_neg, fill = bio_sex)
) +
  geom_bar() + 
  facet_wrap(~ bio_sex) +
  scale_fill_manual(values = c('forestgreen', 'skyblue')) +
  labs(title = 'Bar Plot of Simulated Binary Outcome and Sex Assigned\nat Birth(n=30)') +
  xlab('Simulated Binary Variable') +
  theme(panel.grid = element_blank(),panel.background = element_blank(), 
        legend.position = 'none', text = element_text(family = 'serif'))
neg_binary_sex_bar  # view plot

# frequency table
neg_binary_sex_freq <- table(sim_data$outcome_bin_neg, sim_data$bio_sex)
neg_binary_sex_freq   # view stats

# chi-square test
neg_binary_sex_chi <- chisq.test(sim_data$outcome_bin_neg, sim_data$bio_sex)
neg_binary_sex_chi   # view test results


### by gender identity example ---------------------------------------------

# bar plot
neg_binary_gi_dens <- ggplot(
  sim_data, aes(x = gen_id, fill = outcome_bin_neg)
) +
  geom_density(alpha = 0.7) + 
  scale_fill_manual(values = c('forestgreen', 'skyblue')) +
  labs(title = 'Density Plots of Simulated Binary Outcome and Gender Identity\n(n=30)') +
  xlab('Feminine - Masculine Continuum') +
  theme_classic() +
  theme(
    text = element_text(family = 'serif'),
    axis.ticks.x = element_blank(),
    axis.text.x = element_blank()
  )
neg_binary_gi_dens  # view plot

# t test
neg_binary_gi_ttest <- t.test(gen_id ~ outcome_bin_neg, data = sim_data)
neg_binary_gi_ttest   # view test results


### by gender roles example ------------------------------------------------

# bar plot
neg_binary_grole_dens <- ggplot(
  sim_data, aes(x = gen_role, fill = outcome_bin_neg)
) +
  geom_density(alpha = 0.7) + 
  # facet_wrap(~ sim_binary) +
  scale_fill_manual(values = c('forestgreen', 'skyblue')) +
  labs(title = 'Density Plots of Simulated Binary Outcome and Gender Roles\n(n=30)') +
  xlab('Feminine - Masculine Continuum') +
  theme_classic() +
  theme(
    text = element_text(family = 'serif'),
    axis.ticks.x = element_blank(),
    axis.text.x = element_blank()
  )
neg_binary_grole_dens  # view plot

# t test
neg_binary_grole_ttest <- t.test(gen_role ~ outcome_bin_neg, data = sim_data)
neg_binary_grole_ttest   # view test results

