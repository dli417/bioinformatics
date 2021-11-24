# notes

## Q&A

- How do we decide what models we should test?
  - Statistics is inefficient, cannot easily *a priori* device what models to test, what predictors to include
  - Try to find a model that fits as well as possible, by understanding structure of data
    - i.e. binomial, poisson, gaussian
  - `fitdistrplus` package to help find possible model
  - Test using AIC which model fits data best
  - 