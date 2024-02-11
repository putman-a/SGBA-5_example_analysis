###############################################################################
#####                      Simulate Data for SGBA                         #####
#####                                                                     #####
#####                           by: A Putman                              #####
###############################################################################

##### load libraries #####
# load libraries
library(tidyverse)

# set seed for reproducibility
set.seed(42)

##### write simulation functions #####
# function for simulating bimodal gender variables (loosely based on test-retest sample) 
binom.sim.bounded <- function(n, binom.prop, mean1, sd1, mean2, sd2, lower.lim = -Inf, upper.lim = Inf, rounding.decimal){
  # error checking
  if(binom.prop > 1 || binom.prop< 0){stop("binomial proportion should be between 0 and 1")}
  if(n < 1){stop("n must be greater than or equal to 1")}
  if(sd1 < 0 || sd2 < 0){stop("standard deviations must be non-negative")}
  # create index
  index <- rbinom(n, size = 1, prob = binom.prop)
  # simulate each peak using a bounded rnorm
  sim.sample.1 <- index * qnorm(runif(n, pnorm(lower.lim, mean1, sd1), pnorm(upper.lim, mean1, sd1)), mean1, sd1)
  sim.sample.0 <- (1 - index) * qnorm(runif(n, pnorm(lower.lim, mean2, sd2), pnorm(upper.lim, mean2, sd2)), mean2, sd2)
  sim.sample <- sim.sample.0 + sim.sample.1
  sim.sample <- round(sim.sample, rounding.decimal)
  sim.sample
}

# function for simulating likert/ordered outcome variable
ord.sim <- function(n, mean, sd, lower.lim = -Inf, upper.lim = Inf){
  sim <- qnorm(runif(n, pnorm(lower.lim, mean, sd), pnorm(upper.lim, mean, sd)), mean, sd)
  sim <- round(sim, 0)
  sim
}

##### simulate data with a sample size of 30 #####
# biological sex - categorical: female,intersex,male
sex <- factor(sample(c('Female', 'Male'), 30, replace=TRUE, prob=c(0.6, 0.4)))
# gender identity - ordered: 0:100 (from feminine to masculine)
gen_id <- binom.sim.bounded(
  n = 30, binom.prop = 0.6, mean1 = 20, sd1 = 20, mean2 = 85, sd2 = 15,
  lower.lim = 0, upper.lim = 100, rounding.decimal = 0
)
# gender role - ordered: 0:100 (from feminine to masculine)
gen_role <- binom.sim.bounded(
  n = 30, binom.prop = 0.6, mean1 = 25, sd1 = 20, mean2 = 80, sd2 = 20, 
  lower.lim = 0, upper.lim = 100, rounding.decimal = 0
)
# simulated outcome1 - continuous: mean of 10 with sd of 3
sim_num <- rnorm(n = 30, mean = 10, sd = 3)
# simulated outcome2 - ordered: 7-point likert scale, mean of 4 with sd of 2
sim_ord <- ordered(ord.sim(n = 30, mean = 4, sd = 2, lower.lim = 1, upper.lim = 7))
# simulated outcome3 - binary category: achieved (yes, no)
sim_binary <- factor(sample(c('yes','no'), 30, replace = T, prob = c(0.67,0.33)))

# combine into dataframe
sim_data <- tibble(sex, gen_id, gen_role, sim_num, sim_ord, sim_binary)

# save simulated df
write_rds(sim_data, file = "~/[DESIREDFOLDER]/sim.data.RDS") # replace [DESIREDFOLDER] with folder to save data set into
