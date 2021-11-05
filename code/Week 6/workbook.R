# Libraries
library(tidyverse)
library(vroom)
library(lubridate)
library(multcomp)

# Normal disctribution sample size test
hist(rnorm(420, mean = 161.6, sd = 8.8))

# 2.1 GLM with categorical predictors

##load the iris data set
data("iris")

# 2.1.1 Visualise your data

## Plot the sepal widths so we can visualise if there are differences between the different species
ggplot(iris, aes(x=Species, y=Sepal.Width)) +
  geom_jitter(aes(col=Species)) +
  theme_bw()

ggplot(iris, aes(x=Sepal.Width, fill = Species)) +
  ## bin width determines how course the histogram is
  ## the alpha determines the transparency of the bars
  ## position allows you to determine what kind of histogram you plot (e.g. stacked vs overlapping). try changing to position="stack"
  geom_histogram(binwidth = .1, alpha = .5, position="identity")

# 2.1.2 Code a GLM

##fit a glm()
## glm(y ~ x); ~ = "As a function of"
mod_iris <- glm(Sepal.Width ~ Species,
            ##specify the data
            data = iris,
            ##specify the error structure
            family = "gaussian")

# 2.1.3 Assesing the fit of our model

##display the class of the model object
class(mod_iris)

##display the class of the model object
#devAskNewPage(ask = TRUE)
plot(mod_iris)

# 2.1.4 Model summaries and outputs

##summarise the model outputs
summary(mod_iris)

# 2.1.5 Multiple comparisons test

## load the multcomp pack
#library(multcomp)

## run the multiple comparisons, and look at the summary output:
summary(glht(mod_iris, mcp(Species="Tukey")))

# 2.2 GLM with continuous predictors

# load in species data fron week 4 homework

##read in the data
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
wide_spp.1 <- vroom("../../data/Workshop 3/to_sort_pop_1.csv")
wide_spp.2 <- vroom("../../data/Workshop 3/to_sort_pop_2.csv")

## code to reshape data
## first join the data using full join - this will keep all of the columns
long_spp <- full_join(wide_spp.1, wide_spp.2) %>%
              ## pivot the joined data frame, using species, primary_threat, secondary_threat, tertiary_threat as ID columns
              ## and using names-pattern to pull out the population number
              ## and make a new column (called population) to store them in.
              ##Drop the NAs.
               pivot_longer(cols = -c(species,
                                      primary_threat,
                                      secondary_threat,
                                      tertiary_threat),
                            names_to = c("population", "date"),
                            names_pattern = "(.*)_(.*)",
                            values_drop_na = T,
                            values_to = "abundance")
print(long_spp)

# Set date column to date format
long_spp$date <- as.Date(long_spp$date, "%Y-%m-%d")

# Filter the data to make a new data frame called single_spp containing only data on Trichocolea tomentella
single_spp <- long_spp %>% filter(species == "Trichocolea tomentella")
print(single_spp)

# Visualise data prior to data analysis
##make the plot
p1 <- ggplot(single_spp, aes(x = date, y = abundance)) +
  geom_point() +
  geom_line() +
  theme_bw() +
  ylab("Abundance") +
  xlab("Year")
##add the loess smoothing:
p1 + geom_smooth(method = "loess")

## calculate a new column (`standardised_time`) which is the difference between the
## starting date of the time series and each other date in weeks (see ?difftime)
## we will set this to a numeric vector
single_spp <- single_spp %>%
                mutate(standardised_time = as.numeric(difftime(as.Date(date),
                                                               min(as.Date(date)),
                                                               units = "weeks")))

print(single_spp[,c("abundance", "date", "standardised_time")], 30)

##fit a glm()
mod1 <- glm(abundance ~ standardised_time,
            data = single_spp,
            family = "gaussian")
print(mod1)

# 2.2.1 Assesing the fit of a model

##return the predicted (response) values from the model
##and add them to the single species tibble:
single_spp$pred_gaussian <- predict(mod1,
                                    type = "response")

# Use the resid() function to add the residuals of the model to the data.frame
# in the same was as you added the predicted values.
single_spp$resid_gaussian <- resid(mod1)

## plot the abundances through time
p2 <- ggplot(single_spp, aes(x = standardised_time,
                             y = abundance)) +
  geom_point() +
  geom_line() +
  theme_bw() +
  ylab("Abundance") +
  xlab("standardised_time")

##add in a line of the predicted values from the model
p2 <- p2 + geom_line(aes(x = standardised_time,
                         y = pred_gaussian),
                     col = "dodgerblue",
                     size = 1)

## we can also add in vertical blue lines which show the residual error of the model
## (how far the observed points are from the predicted values).
## in geom_segement we specify where we want the start and end of the segments (lines)
## to be. Without any prompting ggplot assumes that we want the start of the lines to
## be taken from the x and y values we are plotting using the ggplot() function
## i.e. standardised_time and abundance, so we just need to specify the end points of
## the lines:
p2 <- p2 +
  geom_segment(aes(xend = standardised_time,
                   yend = pred_gaussian),
               col = "lightblue")

## add a title
p2 <- p2 + ggtitle("Fitted model (gaussian with identity link)")

##print the plot
p2

##plot a histogram of the residuals from the model using geom_histogram()
p3 <- ggplot(single_spp, aes(x = resid_gaussian)) +
  geom_histogram(fill="goldenrod") +
  theme_minimal() +
  ggtitle("Histogram of residuals (gaussian with identity link)")
## print the plot
p3

# Try to make the plot below using your own code, plotting the predicted vs residuals in the single_spp data.frame

p4 <- ggplot(single_spp,
             aes(x = pred_gaussian,
                 y = resid_gaussian)) +
  geom_point() +
  theme_minimal() +
  xlab("Predicted values") +
  ylab("residuals") +
  ggtitle("Predicted vs residual (gaussian with identity link)") +
  ##using geom_smooth without specifying the method (see later) means geom_smooth()
  ##will try a smoothing function with a formula y~x and will try to use a loess smoothing
  ##or a GAM (generalised additive model) smoothing depending on the number of data points
  geom_smooth(fill="lightblue", col="dodgerblue")

p4

##plot the qq plot for the residuals from the model assuming a normal distribution,
## and add the straight line the points should fall along:
qqnorm(single_spp$resid_gaussian); qqline(single_spp$resid_gaussian)

# 2.2.1.1 Exploring alternative models

## fit a glm with a poisson distribution
mod2 <- glm(abundance ~ standardised_time,
            data = single_spp,
            family = "poisson")
mod2

## fit a glm with a gaussian distribution with a log link
mod3 <- glm(abundance ~ standardised_time,
            data = single_spp,
            family = gaussian(link = "log"))
mod3

## we could also try a guassian model with an inverse link
mod4 <- glm(abundance ~ standardised_time,
            data = single_spp,
            family = gaussian(link = "inverse"))
mod4

##compare the models
AIC_mods <- AIC(mod1,
                mod2,
                mod3,
                mod4)

## rank them by AIC using the order() function
AIC_mods[order(AIC_mods$AIC),]

# Produce the plot below, adapting the code we developed earlier to produce the plot with the fits and residuals for a gaissian distribution with a identity link.
##return the predicted (response) values from the model and add them to the single species tibble:
single_spp$pred_gaussian_log <- predict(mod3,
                                    type="response")

##return the model residuals and add to the single species tibble:
single_spp$resid_gaussian_log <- resid(mod3)

##first off let's plot the data again, and add in the predicted values from the model as a line. We can modify the plot we started earlier:
p5 <- ggplot(single_spp, aes(x=standardised_time, y=abundance)) +
  geom_point() +
  geom_line() +
  theme_bw() +
  ylab("Abundance") +
  xlab("standardised_time")

##add in a line of the predicted values from the model
p5 <- p5 + geom_line(aes(x = standardised_time,
                         y = pred_gaussian_log),
                     col = "dodgerblue",
                     size = 1)

## we can also add in lines showing the distance of each observation from
## the value predicted by the model (i.e. these lines visualise the residual error)
p5 <- p5 + geom_segment(aes(xend = standardised_time,
                            yend = pred_gaussian_log),
                            col="lightblue")

## add a title
p5 <- p5 + ggtitle("Fitted model (gaussian with log link)")

##print the plot
p5

##plot the diagnostic graphics for model 3
plot(mod3)

# 2.2.2 Model summaries and outputs

##summarise the model outputs
summary(mod3)

## first off let's plot the data again
p6 <- ggplot(single_spp, aes(x=standardised_time, y=abundance)) +
  geom_point() +
  geom_line() +
  theme_bw() +
  ylab("Abundance") +
  xlab("standardised_time")

## use the geom_smooth() function to add the regression to the plot.
## unlike earlier here we are specifying the model type (glm), the formula,
## and the error structure and link
p6 <- p6 + geom_smooth(data=single_spp,
                       method="glm",
                       method.args = list(family = gaussian(link="log")),
                       formula = y ~ x,
                       col = "dodgerblue",
                       fill = "lightblue")

##print the plot
p6
