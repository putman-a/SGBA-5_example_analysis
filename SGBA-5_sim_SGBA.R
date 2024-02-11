###############################################################################
#####                       SGBA of Simulated Data                        #####
#####                                                                     #####
#####                           by: A Putman                              #####
###############################################################################

##### load libraries and simulated data #####
# load libraries
library(tidyverse)
library(ggpubr)
library(extrafont)  # for exporting plots with Times New Roman Font

# set seed for reproducibility
set.seed(42)

# load data set (from RDS if using previous script to simulate the data)
sim_df <- read_rds(file = '[SIMULATEDDATASET].RDS')  # replace [SIMULATEDDATASET] with location of data set

#####  store plot theme presets  #####
# store plot aspects for easy reuse
plot.theme <-   
  theme_classic() +
  theme(
    text = element_text(family = 'serif'),
    legend.position = 'none',
    axis.ticks.x = element_blank(),
    axis.text.x = element_blank()
  )

# default density plots and scale
plot.2d.density <- function(data, x, y){
  z <- ggplot(data = data, aes(x = x, y = y)) + 
    geom_density_2d_filled(aes(fill = after_stat(level)),
                           bins = 9, contour_var = 'ndensity') +
    scale_fill_brewer(palette = 16, direction = 1, 
                      labels = c('Low', '', '', '','','','','', 'High')) +
    guides(fill = guide_legend(title = 'Density of Occurences', 
                               direction = 'horizontal', nrow = 1, 
                               label.position = 'bottom'))
  z
}


#####  univariate plots  #####
# biological sex bar plot
sex_bar <- ggplot(sim_df, aes(x = sex)) +
  geom_bar(aes(fill = sex), show.legend = F) + 
  labs(title = 'Barplot of Simulated\nBiological Sex (n=30)') +
  ylab('Count') + xlab('Biological Sex') +
  theme_classic() +
  theme(text = element_text(family = 'serif'))
sex_bar  # view plot

# gender identity density plot
gi_dens <- ggplot(sim_df, aes(x = gen_id)) +
  geom_density(alpha=.5, fill = 'forestgreen', colour = 'black') +
  labs(title = 'Densityplot of Simulated\nGender Identity (n=30)') +
  ylab('Density') + xlab('Feminine - Masculine Continuum') +
  plot.theme  
gi_dens  # view plot

# gender role density plot
grol_dens <- ggplot(sim_df, aes(x = gen_role)) +
  geom_density(alpha=.5, fill = 'purple2', colour = 'black') +
  labs(title = 'Densityplot of Simulated\nGender Role (n=30)') +
  ylab('Density') + xlab('Feminine - Masculine Continuum') +
  plot.theme  
grol_dens  # view plot


##### SGBA #####

##### continuous variable by biological sex example #####
# density plot
con_sex_dens <- ggplot(sim_df, aes(x = sim_num, fill = sex)) + 
  geom_density(alpha = 0.7) +
  scale_fill_manual(values = c('forestgreen', 'skyblue')) +
  labs(title = 'Density Plot of Simulated Continuous Variable by Biological Sex (n=30)') +
  xlab('Continuous Outcome') + ylab('Response Density') +
  theme_classic() + 
  theme(legend.position = 'bottom', text = element_text(family = 'serif'))
con_sex_dens  # view plot

# summary stats
con_sex_sum <- sim_df %>% group_by(sex) %>% 
  summarise(
    n = n(), 
    `mean continuous` = round(mean(sim_num),1),
    `SD continuous` = round(sd(sim_num),2),
    `median continuous` = round(median(sim_num),0),
    `IQR continuous` = round(IQR(sim_num),)
  ) %>% 
  rename(`biological sex` = sex) 
con_sex_sum   # view stats

# t test
con_sex_ttest <- t.test(sim_num ~ sex, data = sim_df)
con_sex_ttest   # view test results


##### continuous variable by gender identity example #####
# scatter plot
num_gi_scatter <- ggplot(data = sim_df, aes(x = gen_id, y = sim_num)) + 
  geom_jitter(size = 3, colour = 'forestgreen') + 
  #  labs(title = 'Scatterplot of Simulated Numerical Outcome\n& Gender Identity (n=30)') +
  ylab('Continuous Outcome') + xlab('Feminine - Masculine Continuum') +
  plot.theme
num_gi_scatter  # view plot

# 2D density plot
num_gi_density2d <- plot.2d.density(sim_df, gen_id, sim_num) +
  #  labs(title = '2D Density of Simulated Numerical\nOutcome & Gender Identity (n=30)') +
  ylab('Continuous Outcome') + xlab('Feminine - Masculine Continuum') +
  plot.theme
num_gi_density2d  # view plot

# Pearson's r
num_gi_cor <- cor.test(sim_df$sim_num, sim_df$gen_id, method='pearson')
num_gi_cor   # view test results


##### continuous variable by gender role example #####
# scatter plot
num_role_scatter <- ggplot(sim_df, aes(x = gen_role, y = sim_num)) + 
  geom_jitter(size = 3, colour = 'forestgreen') + 
  #  labs(title = 'Scatterplot of Simulated Numerical Outcome\n& Gender Role') +
  ylab('Simuluated Continuous Outcome') + xlab('Feminine - Masculine Continuum') +
  plot.theme
num_role_scatter  # view plot

# 2D density plot
num_role_density2d <- plot.2d.density(sim_df, gen_role, sim_num) +
  #  labs(title = '2D Density of Simulated Numerical\nOutcome & Gender Role (n=30)') +
  ylab('Simuluated Continuous Outcome') + xlab('Feminine - Masculine Continuum') +
  plot.theme
num_role_density2d  # view plot

# Pearson's r
num_grol_cor <- cor.test(sim_df$sim_num, sim_df$gen_role, method='pearson')
num_grol_cor   # view test results


##### ordinal variable by biological sex example #####
# bar plot
ord_sex_bar <- ggplot(sim_df, aes(x = sim_ord, fill = sex)) +
  geom_bar() + 
  facet_wrap(~ sex) +
  scale_fill_manual(values = c('forestgreen', 'skyblue')) +
  labs(title = 'Bar Plot of Simulated Likert Outcome and Sex Assigned\nat Birth(n=30)') +
  xlab('Simulated Likert Scale Variable') +
  theme(panel.grid = element_blank(),panel.background = element_blank(), 
        legend.position = 'none', text = element_text(family = 'serif'))
ord_sex_bar  # view plot

# summary stats
ord_sex_sum <- sim_df %>% group_by(sex) %>% 
  summarise(
    n = n(), 
    `median Likert` = round(median(as.numeric(sim_ord)),0),
    `IQR Likert` = round(IQR(as.numeric(sim_ord)),)
  ) %>% 
  rename(`biological sex` = sex) 
ord_sex_sum   # view stats

# chi-square test
ord_sex_chi <- chisq.test(sim_df$sim_ord,sim_df$sex)
ord_sex_chi   # view test results


##### ordinal variable by gender identity example #####
# jitter
ord_gi_jit <- ggplot(sim_df, aes(x = gen_id, y = sim_ord)) + 
  geom_jitter(aes(colour = sim_ord, alpha = 0.7), size = 4, height = 0.1) +
  # labs(title = 'Scatterplot of Simulated Likert Outcome\n& Gender Identity (n=30)') +
  xlab('Feminine - Masculine Continuum') + ylab('Simuluated Likert Outcome') +
  geom_hline(yintercept = c(1.5, 2.5, 3.5, 4.5, 5.5, 6.5), linetype='dashed', colour='grey') +
  plot.theme
ord_gi_jit  # view plot

# 2D Density
ord_gi_den <- plot.2d.density(sim_df, gen_id, as.numeric(sim_ord)) +
  scale_y_continuous(breaks = c(1,2,3,4,5,6,7), labels = c(1,2,3,4,5,6,7), limits = c(1,7)) +
  # labs(title = '2D Density of Simulated Likert Outcome\n& Gender Identity (n=30)') +
  xlab('Feminine - Masculine Continuum') + ylab('Simuluated Likert Outcome') + 
  geom_hline(yintercept = c(1.5, 2.5, 3.5, 4.5, 5.5, 6.5)) +
  plot.theme
ord_gi_den  # view plot

## Pearson's r
ord_gi_cor <- cor.test(as.numeric(sim_df$sim_ord), sim_df$gen_id, method='pearson')
ord_gi_cor   # view test results


##### ordinal variable by gender role example #####
# jitter
ord_gr_jit <- ggplot(sim_df, aes(x = gen_role, y = sim_ord)) + 
  geom_jitter(aes(colour = sim_ord, alpha = 0.7), size = 4, height = 0.1) +
  # labs(title = 'Scatterplot of Simulated Likert Outcome\n& Gender Role (n=30)') +
  xlab('Feminine - Masculine Continuum') + ylab('Simuluated Likert Outcome') +
  geom_hline(yintercept = c(1.5, 2.5, 3.5, 4.5, 5.5, 6.5), linetype='dashed', colour='grey') +
  plot.theme
ord_gr_jit  # view plot

## 2D Density
ord_gr_den <- plot.2d.density(sim_df, gen_role, as.numeric(sim_ord)) +
  scale_y_continuous(breaks = c(1,2,3,4,5,6,7), labels = c(1,2,3,4,5,6,7), limits = c(1,7)) +
  # labs(title = '2D Density of Simulated Likert Outcome\n& Gender Role (n=30)') +
  xlab('Feminine - Masculine Continuum') + ylab('Simuluated Likert Outcome') + 
  geom_hline(yintercept = c(1.5, 2.5, 3.5, 4.5, 5.5, 6.5)) +
  plot.theme
ord_gr_den  # view plot        

## Pearson's r
ord_gr_cor <- cor.test(as.numeric(sim_df$sim_ord), sim_df$gen_role, method='pearson')
ord_gr_cor   # view test results


##### binary variable by biological sex example #####
# bar plot
binary_sex_bar <- ggplot(sim_df, aes(x = sim_binary, fill = sex)) +
  geom_bar() + 
  facet_wrap(~ sex) +
  scale_fill_manual(values = c('forestgreen', 'skyblue')) +
  labs(title = 'Bar Plot of Simulated Binary Outcome and Sex Assigned\nat Birth(n=30)') +
  xlab('Simulated Binary Variable') +
  theme(panel.grid = element_blank(),panel.background = element_blank(), 
        legend.position = 'none', text = element_text(family = 'serif'))
binary_sex_bar  # view plot

# frequency table
binary_sex_freq <- table(sim_df$sim_binary, sim_df$sex)
binary_sex_freq   # view stats

# chi-square test
binary_sex_chi <- chisq.test(sim_df$sim_binary,sim_df$sex)
binary_sex_chi   # view test results


##### binary variable by gender identity example #####
# bar plot
binary_gi_dens <- ggplot(sim_df, aes(x = gen_id, fill = sim_binary)) +
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
binary_gi_dens  # view plot

# t test
binary_gi_ttest <- t.test(gen_id ~ sim_binary, data = sim_df)
binary_gi_ttest   # view test results

##### binary variable by gender roles example #####
# bar plot
binary_grole_dens <- ggplot(sim_df, aes(x = gen_role, fill = sim_binary)) +
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
binary_grole_dens  # view plot

# t test
binary_grole_ttest <- t.test(gen_role ~ sim_binary, data = sim_df)
binary_grole_ttest   # view test results
