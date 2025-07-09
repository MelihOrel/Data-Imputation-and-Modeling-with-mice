# Data-Imputation-and-Modeling-with-mice
## 1. Objective

The primary goal of this R script was to demonstrate a complete workflow for handling missing data in a statistical analysis. The process involved:

1.  Simulating a dataset with missing values.
2.  Using the `mice` package to perform multiple imputation.
3.  Building a linear regression model on the imputed data.
4.  Interpreting the final, pooled results to understand the relationship between variables.

The specific goal of the model was to predict a person's `weight` based on their `age` and `height`.

---

## 2. Methodology

The analysis followed these key steps:

* **Data Simulation**: A sample dataset (`df`) was created with 100 observations and three integer variables: `age`, `height`, and `weight`.

* **Introducing Missingness**: To simulate a real-world scenario, missing values (`NA`) were deliberately introduced into the dataset:
    * 10% of the values in the `age` column were randomly set to `NA`.
    * 15% of the values in the `weight` column were randomly set to `NA`.

* **Multiple Imputation**: The `mice()` function was used to handle the missing data.
    * `m = 5`: The function generated 5 different complete datasets, which is a core principle of multiple imputation that accounts for the uncertainty of the missing values.
    * `method = 'pmm'`: "Predictive Mean Matching" was used for the imputation. This method is ideal for integer data as it borrows an actual observed value from a similar record, ensuring that the imputed values are plausible (e.g., it won't impute an age of 41.7).

* **Modeling and Pooling**:
    * A linear regression model (`lm(weight ~ age + height)`) was fitted to each of the 5 imputed datasets using the `with()` function.
    * The results from these 5 separate models were then combined into a single, robust summary using the `pool()` function, which applies Rubin's Rules for combining estimates.

---

## 3. Results and Interpretation

The final, pooled summary of the linear model was as follows:

| term        |   estimate | std.error | statistic |      df |      p.value |
| :---------- | ---------: | --------: | --------: | ------: | -----------: |
| (Intercept) | -10.975304 | 12.010178 | -0.913834 | 93.3006 | 3.629e-01    |
| age         |   0.198308 |  0.076395 |  2.595828 | 94.6290 | 1.096e-02    |
| height      |   0.490159 |  0.067340 |  7.279313 | 94.9455 | 3.033e-11    |

From this table, we can draw the following conclusions:

* **Age**: The `p.value` for age is **0.011**, which is less than the standard threshold of 0.05. This indicates that **age is a statistically significant predictor of weight**. The `estimate` of 0.198 suggests that for every one-year increase in age, weight is expected to increase by 0.198 kg, holding height constant.

* **Height**: The `p.value` for height is extremely small (**3.03e-11**). This shows that **height is a very strong and statistically significant predictor of weight**. The `estimate` of 0.490 suggests that for every 1 cm increase in height, weight is expected to increase by 0.490 kg, holding age constant.

---

## 4. Conclusion

The analysis successfully demonstrated how to build a reliable statistical model even when faced with missing data. By using the `mice` package, we were able to impute the missing values and create a linear regression model which showed that both `age` and `height` have a significant positive effect on `weight`.
