---
title: "Week 3 Homework"
author: "Daniel Li"
date: "13/10/2021"
output:
  html_document:
    toc: true
    toc_float: true
    number_sections: true
    toc_depth: 3
---

# Task

Write an Rmarkdown describing (and including code to do) the following:

- load to_sort_pop_1.csv and to_sort_pop_1.csv from [bioinformatics_data](https://github.com/chrit88/Bioinformatics_data/tree/master/Workshop%203) on github.
- these data are population counts for endangered species. The first four columns should be self explanitory (the species binomial, and the primary, secondary, and tertiary threat each species is being threatened by). The rest of the columns specify the population counts for given dates. If you compare the two data (to_sort_pop_1.csv vs to_sort_pop_1.csv) you will see that the population is specified in the names of the date columns.
- using tidyverse join both of these data together into a single tibble
  - you haven’t met the join function yet, but 90% of being a good coder (and hence bioinformatician) is being good at googling and learning how to learn code!
- reshape them from wide to long format
- make sure when you do this that you end up with (1) a column specifying which population the data are from (i.e. population 1 or 2), (2) a column specifying the date the data were collected, (3) a column with the population abundance estimates in it, and (4) that any missing values are dropped from the data. I.e. your data.frame should look like the figure below.
- do the above with the minimum amount of code (hint - %>%!)
- In your RMarkdown make sure you explain what you have done and show your annotated code.


# Code

```{r}
# Load packages
library(vroom)
library(tidyverse)
```

Load to_sort_pop_1.csv and to_sort_pop_2.csv

```{r}
# load datasets and assign to variables
to_sort_pop_1 <- vroom("../../data/Workshop 3/to_sort_pop_1.csv")
to_sort_pop_2 <- vroom("../../data/Workshop 3/to_sort_pop_2.csv")
```

Using tidyverse join both of these data together into a single tibble

```{r}
# use full_join to retain all values and rows
total_data <- full_join(to_sort_pop_1, to_sort_pop_2)
```

Reshape them from wide to long format

```{r}
total_data_long <- total_data %>%
                            pivot_longer(cols = -c(species:tertiary_threat),
                                         names_to = "population.date",
                                         values_to = "abundance",
                                        )
```

Do the above but split population.date into two columns with the minimum amount of code

```{r}
total_data_long <- total_data %>%
                            pivot_longer(cols = -c(species:tertiary_threat),
                                         names_to = c("population", "date"),
                                         values_to = "abundance",
                                         names_pattern = "pop_?(.*)_(.*)"
                                        )
```

