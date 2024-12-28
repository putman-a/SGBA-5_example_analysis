# SGBA of a Continuous Variable {#continuous}



> *Note 1: for conciseness, the following examples will only show results for two of the four gendered aspects of health items from the SGBA-5 (gender identity, and gender roles)*

> *Note 2: for each of the following sections, an example outcome variable that demonstrates a relationship between that variable and the SGBA-5 item being assessed - the interaction example - and an example that does not demonstrate a relationship between itself and the SGBA-5 item - the no interaction example - are shown.*


## Biological Sex

A good idea is to start by visualizing the continuous variable’s distribution disaggregated by sex like the density plot in Figure \@ref(fig:04-binary-pos-plot). Then calculate disaggregated summary statistics for the continuous variable disaggregated by sex (Tables \@ref(tab:03-tab-int) and  \@ref(tab:03-tab-no-int)), and conduct a statistical test of difference in means (Welch’s t-test for this example).


### Density Plots

<div class="figure" style="text-align: center">
<img src="03-continuous_files/figure-html/04-binary-pos-plot-1.png" alt="Density Plot of Continuous Variable by Biological Sex Examples" width="50%" /><img src="03-continuous_files/figure-html/04-binary-pos-plot-2.png" alt="Density Plot of Continuous Variable by Biological Sex Examples" width="50%" />
<p class="caption">(\#fig:04-binary-pos-plot)Density Plot of Continuous Variable by Biological Sex Examples</p>
</div>

**Interpretation:** From the above density plots (Figure \@ref(fig:04-binary-pos-plot)) we can see a distinct overlap in the **no interaction example** with suggests that in that example's sample does not have a meaningful difference in the continuous outcome by sex. Conversely, the **interaction example** density plot has two distinct peaks which suggests that its sample's continuous outcome scores are associated with a participant's sex.


### Summary Statistics


Table: (\#tab:03-tab-int)Interation example summary statisitics: Continuous outcome and biological sex

|biological sex |  n| mean continuous| SD continuous| median continuous| IQR continuous|
|:--------------|--:|---------------:|-------------:|-----------------:|--------------:|
|Female         | 14|             3.5|          1.94|                 4|              2|
|Male           | 16|            11.3|          2.95|                11|              2|


Table: (\#tab:03-tab-no-int)No interation example summary statisitics: Continuous outcome and biological sex

|biological sex |  n| mean continuous| SD continuous| median continuous| IQR continuous|
|:--------------|--:|---------------:|-------------:|-----------------:|--------------:|
|Female         | 14|             9.0|          1.84|                 9|              2|
|Male           | 16|            10.8|          3.47|                11|              3|

**Interpretation:** As with the density plots, we see that the standard deviations of the continuous variable for both males and females overlap in the **no interaction example** (Table \@ref(tab:03-tab-int)) - indicating a lack of significant difference by sex. The standard deviations of the continuous variable for both males and females do not overlap in the **interaction example** (Table \@ref(tab:03-tab-no-int)) - indicating a potential association between that continuous outcome variable and sex.


### Statistical Test

**No interaction: Welch's t-test**

Table: (\#tab:unnamed-chunk-1)Statistical test of difference: Continuous outcome and biological sex.

|Example        |Test           | T-score|95% CI         |   df| p-value|
|:--------------|:--------------|-------:|:--------------|----:|-------:|
|Interaction    |Welch's t-test |   -8.73|(-9.72, -6.02) | 26.1|   0.000|
|No interaction |Welch's t-test |   -1.80|(-3.85, 0.26)  | 23.4|   0.084|

