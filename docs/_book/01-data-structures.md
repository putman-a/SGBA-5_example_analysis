# Data Structure {#data-structure}

## Collected SGBA-5 Responses

After collecting responses from the SGBA-5 you will have a dataset that looks something like this:


```
## ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
## ✔ dplyr     1.1.4     ✔ readr     2.1.5
## ✔ forcats   1.0.0     ✔ stringr   1.5.1
## ✔ ggplot2   3.5.1     ✔ tibble    3.2.1
## ✔ lubridate 1.9.3     ✔ tidyr     1.3.1
## ✔ purrr     1.0.2     
## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
## ✖ dplyr::filter() masks stats::filter()
## ✖ dplyr::lag()    masks stats::lag()
## ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors
```



Table: (\#tab:01-data)Example Data Structure

| pt_id|sex    | gen_id| gen_exp| gen_role| gen_rel|
|-----:|:------|------:|-------:|--------:|-------:|
|     1|Female |     48|      99|       70|      25|
|     2|Male   |    100|      17|       99|       2|
|     3|Female |     64|      48|       88|      40|
|     4|Female |     24|      46|       36|      88|
|     5|Male   |     73|      23|       19|      26|

__Note:__
The values in this table are placeholders for the example, not real data

Where:  

`pt_id` is the participant identifier.  

`sex` is the SGBA-5 categorical Biological Sex item.  

  - response options of "male", "female", and "intersex".  

`gen_id` is the SGBA-5 Gender Identity gendered aspect of health item.  

  - Responses are recorded as ordinal values between 0 to 100 on a feminine to masculine scale (measured in mm if completed on paper).  

`gen_exp` is the SGBA-5 Gender Expression gendered aspect of health item.  

  - Responses are recorded as ordinal values between 0 to 100 on a feminine to masculine scale (measured in mm if completed on paper).  

`gen_role` is the SGBA-5 Gender Role gendered aspect of health item.  

  - Responses are recorded as ordinal values between 0 to 100 on a feminine to masculine scale (measured in mm if completed on paper).  

`gen_rel` is the SGBA-5 Gender Relations gendered aspect of health item.  

  - Responses are recorded as ordinal values between 0 to 100 on a feminine to masculine scale (measured in mm if completed on paper).


## Simulated Data

This example analysis uses simulated data, if you wish to replicate the simulate data the code to do so is included in [Appendix A]() or can be downloaded from this example's [github page](https://github.com/putman-a/SGBA-5_example_analysis/%s).
