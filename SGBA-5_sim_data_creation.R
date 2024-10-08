# load libraries ----------------------------------------------------------

library(tidyverse)

# set seed for predictability
set.seed(42, kind = "Mersenne-Twister")

# write simulation functions ----------------------------------------------

# function for simulating bimodal gender variables
binom_bounded <- function(
    n, prop, mean1, sd1, mean2, sd2, lim_low = -Inf, lim_up = Inf, round
    ){
  # error checking
  if(prop > 1 || prop< 0){stop("binomial proportion should be between 0 and 1")}
  if(n < 1){stop("n must be greater than or equal to 1")}
  if(sd1 < 0 || sd2 < 0){stop("standard deviations must be non-negative")}
  # create index
  index <- rbinom(n, size = 1, prob = prop)
  # simulate each peak using a bounded `rnorm()`
  binom_sim1 <- index * qnorm(
    runif(
      n, pnorm(lim_low, mean1, sd1), pnorm(lim_up, mean1, sd1)
      ), 
    mean1, sd1)
  binom_sim0 <- (1 - index) * qnorm(
    runif(
      n, pnorm(lim_low, mean2, sd2), pnorm(lim_up, mean2, sd2)
      ), 
    mean2, sd2)
  binom_sim <- binom_sim0 + binom_sim1
  binom_sim <- round(binom_sim, round)
  binom_sim
}


# function for simulating Likert/ordinal outcome variable
ordinal_sim <- function(
    n, mean, sd, lim_low = -Inf, lim_up = Inf
    ){
  ord_sim <- qnorm(
    runif(
      n, pnorm(lim_low, mean, sd), pnorm(lim_up, mean, sd)
      ),
    mean, sd)
  ord_sim <- round(ord_sim, 0)
  ord_sim
}


# simulate SGBA-5 data with n of 30 -------------------------------------

# biological sex: categorical (female, intersex, male)
bio_sex <- factor(
  sample(c('Female', 'Male'), 30, replace=TRUE, prob=c(0.6, 0.4)),
  )

# gender identity: ordered (0 [feminine] to 100 [masculine])
gen_id <- binom_bounded(
  n = 30, prop = 0.6, mean1 = 20, sd1 = 20, mean2 = 85, sd2 = 15, lim_low = 0,
  lim_up = 100, round = 0
)

# gender role: ordered (0 [feminine] to 100 [masculine])
gen_role <- binom_bounded(
  n = 30, prop = 0.6, mean1 = 25, sd1 = 20, mean2 = 80, sd2 = 20, lim_low = 0,
  lim_up = 100, round = 0
)


# simulate example positive outcome data with n of 30 -----------------------

## simulated numerical outcome: --------------------------------------------

# by sex: males (mean = 12, SD = 3), females (mean = 4, sd = 2)
outcome_num_pos_m <- rnorm(n = 16, mean = 12, sd = 3)
outcome_num_pos_f <- rnorm(n = 14, mean = 4, sd = 2)
outcome_num_pos_sex <- c(outcome_num_pos_f, outcome_num_pos_m)

# by g_id: high (mean = 12, SD = 3), low (mean = 4, sd = 2)
outcome_num_pos_gid_high <- rnorm(n = 15, mean = 12, sd = 3)
outcome_num_pos_gid_low <- rnorm(n = 15, mean = 4, sd = 2)
outcome_num_pos_gid <- c(outcome_num_pos_gid_high, outcome_num_pos_gid_low)

# by g_role: high (mean = 12, SD = 3), low (mean = 4, sd = 2)
outcome_num_pos_grol_high <- rnorm(n = 12, mean = 12, sd = 3)
outcome_num_pos_grol_low <- rnorm(n = 18, mean = 7, sd = 2)
outcome_num_pos_grol <- c(outcome_num_pos_grol_high, outcome_num_pos_grol_low)


## simulated Likert outcome: ---------------------------------------------

# by sex males (mean = 2, SD = 1), females (mean = 5, sd = 2)
outcome_ord_pos_m <- ordinal_sim(
  n = 16, mean = 2, sd = 1, lim_low = 1, lim_up = 7
)
outcome_ord_pos_f <- ordinal_sim(
  n = 14, mean = 5, sd = 1, lim_low = 1, lim_up = 7
)
outcome_ord_pos_sex <- c(outcome_ord_pos_f, outcome_ord_pos_m) %>%
  factor(., levels = c(1,2,3,4,5,6,7), ordered = TRUE)


# by g_id: high (mean = 5, SD = 2), low (mean = 1, sd = 2)
outcome_ord_pos_high <- ordinal_sim(
  n = 15, mean = 5, sd = 2, lim_low = 1, lim_up = 7
)
outcome_ord_pos_low <- ordinal_sim(
  n = 15, mean = 1, sd = 2, lim_low = 1, lim_up = 7
)
outcome_ord_pos_gid <- c(outcome_ord_pos_high, outcome_ord_pos_low) %>%
  factor(., levels = c(1,2,3,4,5,6,7), ordered = TRUE)


# by g_role: high (mean = 5, SD = 2), low (mean = 1, sd = 2)
outcome_ord_pos_high <- ordinal_sim(
  n = 12, mean = 5, sd = 2, lim_low = 1, lim_up = 7
)
outcome_ord_pos_low <- ordinal_sim(
  n = 18, mean = 1, sd = 2, lim_low = 1, lim_up = 7
)
outcome_ord_pos_grol <- c(outcome_ord_pos_high, outcome_ord_pos_low) %>%
  factor(., levels = c(1,2,3,4,5,6,7), ordered = TRUE)


## simulated binary outcome: -----------------------------------------------

# by sex males (yes = .2, no = .8), females (yes = .8, no = .2)
outcome_bin_pos_m <- sample(
  c('yes','no'), 16, replace = TRUE, prob = c(.2, .8)
)
outcome_bin_pos_f <- sample(
  c('yes','no'), 14, replace = TRUE, prob = c(.8, .2)
)
outcome_bin_pos_sex <- append(outcome_bin_pos_f, outcome_bin_pos_m) %>%
  factor()


# by g_id: high (yes = .4, no = .6), low (yes = .8, no = .2)
outcome_bin_pos_high <- sample(
  c('yes','no'), 15, replace = TRUE, prob = c(.4, .6)
)
outcome_bin_pos_low <- sample(
  c('yes','no'), 15, replace = TRUE, prob = c(.8, .2)
)
outcome_bin_pos_gid <- append(outcome_bin_pos_high, outcome_bin_pos_low) %>%
  factor()


# by g_rol: high (yes = .3, no = .5), low (yes = .8, no = .2)
outcome_bin_pos_high <- sample(
  c('yes','no'), 12, replace = TRUE, prob = c(.3, .7)
)
outcome_bin_pos_low <- sample(
  c('yes','no'), 18, replace = TRUE, prob = c(.8, .2)
)
outcome_bin_pos_grol <- append(outcome_bin_pos_high, outcome_bin_pos_low) %>%
  factor()


# simulate example negative outcome data with n of 30 -----------------------

# simulated numerical outcome: continuous (mean = 10, SD = 3)
outcome_num_neg <- rnorm(n = 30, mean = 10, sd = 3)

# simulated Likert outcome: 7-point Likert scale (mean = 4, SD = 2)
outcome_ord_neg <- ordinal_sim(
  n = 30, mean = 4, sd = 2, lim_low = 1, lim_up = 7
)

# simulated binary outcome: categorical (yes, no)
outcome_bin_neg <- factor(
  sample(c('yes','no'), 30, replace = TRUE, prob = c(0.67, 0.33))
)


# create example data frame -----------------------------------------------

# combine into dataframe
sim_data <- tibble(
  bio_sex, gen_id, gen_role, outcome_bin_pos, 
  outcome_num_neg, outcome_ord_neg, outcome_bin_neg
  ) %>% arrange(., bio_sex) %>% 
  cbind(., outcome_num_pos_sex) %>%
  cbind(., outcome_ord_pos_sex) %>%
  cbind(., outcome_bin_pos_sex) %>%
  arrange(., gen_id) %>% 
  cbind(., outcome_num_pos_gid) %>% 
  cbind(., outcome_ord_pos_gid) %>%
  cbind(., outcome_bin_pos_gid) %>%
  arrange(., gen_role) %>% 
  cbind(., outcome_num_pos_grol) %>% 
  cbind(., outcome_ord_pos_grol) %>%
  cbind(., outcome_bin_pos_grol) %>%


# save simulated df
write_rds(sim_data, file = "~/[DESIREDFOLDER]/sim.data.RDS") # replace [DESIREDFOLDER] with folder to save data set into
