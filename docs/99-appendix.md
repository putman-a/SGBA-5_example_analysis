# Appendix {#appendix}

## Simulated Data Creation

Below is the code used to create the simulated data that will be used to create the example SGBA seen throughout the rest of this example analysis.


``` r
# load libraries ----------------------------------------------------------
library(tidyverse)
```

```
## ── Attaching core tidyverse packages ──────────────────────────────────────────── tidyverse 2.0.0 ──
## ✔ dplyr     1.1.4     ✔ readr     2.1.5
## ✔ forcats   1.0.0     ✔ stringr   1.5.1
## ✔ ggplot2   3.5.1     ✔ tibble    3.2.1
## ✔ lubridate 1.9.3     ✔ tidyr     1.3.1
## ✔ purrr     1.0.2     
## ── Conflicts ────────────────────────────────────────────────────────────── tidyverse_conflicts() ──
## ✖ dplyr::filter() masks stats::filter()
## ✖ dplyr::lag()    masks stats::lag()
## ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors
```

``` r
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
  bio_sex, gen_id, gen_role, #outcome_bin_pos, 
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
  cbind(., outcome_bin_pos_grol)


# save simulated df
write_csv(sim_data, file = "sim-data.csv")
```

### Session Info for Data Creation


``` r
sessioninfo::session_info(pkgs = "loaded")
```

```
## ─ Session info ───────────────────────────────────────────────────────────────────────────────────
##  setting  value
##  version  R version 4.4.2 (2024-10-31)
##  os       macOS Sequoia 15.4.1
##  system   aarch64, darwin20
##  ui       X11
##  language (EN)
##  collate  en_US.UTF-8
##  ctype    en_US.UTF-8
##  tz       America/Toronto
##  date     2025-04-30
##  pandoc   3.2 @ /Applications/RStudio.app/Contents/Resources/app/quarto/bin/tools/aarch64/ (via rmarkdown)
## 
## ─ Packages ───────────────────────────────────────────────────────────────────────────────────────
##  package     * version    date (UTC) lib source
##  bit           4.5.0      2024-09-20 [1] CRAN (R 4.4.1)
##  bit64         4.5.2      2024-09-22 [1] CRAN (R 4.4.1)
##  bookdown      0.41       2024-10-16 [1] CRAN (R 4.4.1)
##  bslib         0.8.0      2024-07-29 [1] CRAN (R 4.4.0)
##  cachem        1.1.0      2024-05-16 [1] CRAN (R 4.4.0)
##  cli           3.6.3      2024-06-21 [1] CRAN (R 4.4.0)
##  colorspace    2.1-1      2024-07-26 [1] CRAN (R 4.4.0)
##  crayon        1.5.3      2024-06-20 [1] CRAN (R 4.4.0)
##  digest        0.6.37     2024-08-19 [1] CRAN (R 4.4.1)
##  dplyr       * 1.1.4      2023-11-17 [1] CRAN (R 4.4.0)
##  evaluate      1.0.1      2024-10-10 [1] CRAN (R 4.4.1)
##  fansi         1.0.6      2023-12-08 [1] CRAN (R 4.4.0)
##  fastmap       1.2.0      2024-05-15 [1] CRAN (R 4.4.0)
##  forcats     * 1.0.0      2023-01-29 [1] CRAN (R 4.4.0)
##  generics      0.1.3      2022-07-05 [1] CRAN (R 4.4.0)
##  ggplot2     * 3.5.1      2024-04-23 [1] CRAN (R 4.4.0)
##  glue          1.8.0      2024-09-30 [1] CRAN (R 4.4.1)
##  gtable        0.3.6      2024-10-25 [1] CRAN (R 4.4.1)
##  hms           1.1.3      2023-03-21 [1] CRAN (R 4.4.0)
##  htmltools     0.5.8.1    2024-04-04 [1] CRAN (R 4.4.0)
##  jquerylib     0.1.4      2021-04-26 [1] CRAN (R 4.4.0)
##  jsonlite      1.8.9      2024-09-20 [1] CRAN (R 4.4.1)
##  knitr         1.49       2024-11-08 [1] CRAN (R 4.4.1)
##  lifecycle     1.0.4      2023-11-07 [1] CRAN (R 4.4.0)
##  lubridate   * 1.9.3      2023-09-27 [1] CRAN (R 4.4.0)
##  magrittr      2.0.3      2022-03-30 [1] CRAN (R 4.4.0)
##  munsell       0.5.1      2024-04-01 [1] CRAN (R 4.4.0)
##  pillar        1.9.0      2023-03-22 [1] CRAN (R 4.4.0)
##  pkgconfig     2.0.3      2019-09-22 [1] CRAN (R 4.4.0)
##  purrr       * 1.0.2      2023-08-10 [1] CRAN (R 4.4.0)
##  R6            2.5.1      2021-08-19 [1] CRAN (R 4.4.0)
##  readr       * 2.1.5      2024-01-10 [1] CRAN (R 4.4.0)
##  rlang         1.1.4      2024-06-04 [1] CRAN (R 4.4.0)
##  rmarkdown     2.29       2024-11-04 [1] CRAN (R 4.4.1)
##  rstudioapi    0.17.1     2024-10-22 [1] CRAN (R 4.4.1)
##  sass          0.4.9.9000 2024-06-05 [1] Github (rstudio/sass@9228fcf)
##  scales        1.3.0      2023-11-28 [1] CRAN (R 4.4.0)
##  sessioninfo   1.2.2      2021-12-06 [1] CRAN (R 4.4.0)
##  stringi       1.8.4      2024-05-06 [1] CRAN (R 4.4.0)
##  stringr     * 1.5.1      2023-11-14 [1] CRAN (R 4.4.0)
##  tibble      * 3.2.1      2023-03-20 [1] CRAN (R 4.4.0)
##  tidyr       * 1.3.1      2024-01-24 [1] CRAN (R 4.4.0)
##  tidyselect    1.2.1      2024-03-11 [1] CRAN (R 4.4.0)
##  tidyverse   * 2.0.0      2023-02-22 [1] CRAN (R 4.4.0)
##  timechange    0.3.0      2024-01-18 [1] CRAN (R 4.4.0)
##  tzdb          0.4.0      2023-05-12 [1] CRAN (R 4.4.0)
##  utf8          1.2.4      2023-10-22 [1] CRAN (R 4.4.0)
##  vctrs         0.6.5      2023-12-01 [1] CRAN (R 4.4.0)
##  vroom         1.6.5      2023-12-05 [1] CRAN (R 4.4.0)
##  withr         3.0.2      2024-10-28 [1] CRAN (R 4.4.1)
##  xfun          0.49       2024-10-31 [1] CRAN (R 4.4.1)
##  yaml          2.3.10     2024-07-26 [1] CRAN (R 4.4.0)
## 
##  [1] /Library/Frameworks/R.framework/Versions/4.4-arm64/Resources/library
## 
## ──────────────────────────────────────────────────────────────────────────────────────────────────
```
