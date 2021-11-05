# Notes

## Presentation

- Normal distribution is the basis of most statistical techniques
  - T test
  - ANOVA
  - Linear regression
- Normal distribution defined by mean and standard deviation

- Why more samples are important
  - run code below and adjust sample number - higher samples show normal distribution more clearly

```R
hist(rnorm(420, mean = 161.6, sd = 8.8))
```

- Stats fit data to distribution
- Then test how likely the data fit the distribution

## 1.4.1 Refresher on frequentest statistics

Definitions:

- Hypothesis testing and the Null hypothesis
- The normal/gaussian distribution
- The difference between the x and y variables
- The concept of a “best fit line”
- The concept of a linear regression
- The difference between categorical and continuous data
- The terms predictor variable, response variable, variance, residuals, slope

## 1.4.2.2 Why are we studying GLMs?

- ANOVA style analyses with categorical predictors
- Linear regressions with continuous predictor variables
- Mix categorical and continuous predictors in multiple regression analyses
