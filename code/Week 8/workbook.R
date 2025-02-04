library(tidyverse)

# 2.1 Methods for timing code
##long vector
x <- c(1:1e6)

##time a calculation
system.time(sin(x + x^2))

##time a calculation
system.time({
  ##long vector
  x <- c(1:1e6)

  ##calculate the sin of the folliwing
  v <- sin(x + x^2)

  ##put it into a tibble
  data_out <- as_tibble(v)
  })

data_out

##load the microbenchmark package
library(microbenchmark)

##long vector
x <- c(1:1e6)

##approach 1
f_1 <- function(x){
  ##calculate the sin of the folliwing
  v <- sin(x + x^2)

  ##put it into a tibble
  data_out <- as_tibble(v)

  return(data_out)
}

##approach 2
f_2 <- function(x){
  ##calculate the sin of the folliwing
  ##without saving objects v and data_out
  return(as_tibble(sin(x + x^2)))
}

##compare the speeds of the two functions,
##running each 500 times
benchmarks <- microbenchmark(f_1,
                             f_2,
                             times = 1000,
                             unit = "s")

##look at the results
benchmarks

# 2.2 Concise code

##approach 1
f_1 <- function(x){
  ##calculate the sin of the folliwing
  v <- sin(x + x^2)

  ##put it into a tibble
  data_out <- as_tibble(v)

  return(data_out)
}

##approach 2
f_2 <- function(x){
  ##calculate the sin of the folliwing
  ##without saving objects v and data_out
  return(as_tibble(sin(x + x^2)))
}

############################################
## example 1
############################################
## vector of values
x <- c(1, 2, 3, 4, 5, 6, 7)

sample(x, 2)

# example 1 written more concisely
sample(c(1:7), 2)

############################################
## example 2
############################################

data("ToothGrowth")

sub1 <- filter(ToothGrowth, len>10)

sub2 <- filter(sub1, supp=="VC")

ggplot(sub2, aes(x=factor(dose), y=len))+geom_boxplot()+theme_minimal()

# example 2 written more concisely
ggplot((filter(ToothGrowth, len>10, supp=="VC")), aes(x=factor(dose), y=len))+geom_boxplot()+theme_minimal()

# 2.3 Vectorising

vec_1 <- c(3, 4, 5, 2)

vec_2 <- c(1, 2, 3, 4)

vec_1 + vec_2

# 2.3.1 Vectorised vs non-vectorised - an example using loops

## a vector of values
x <- 1:5

##loop along the length of x
for(i in 1:length(x)){
  print(i)
}


##non-vectorised addition function
non_vec_addition <- function(x, y){
  ##define an object to store the values in
  z <- numeric(length(x))

  ##use a loop to add each element of the vectors together in turn
  ##and then save the output into the correct slot in the z vector
  for(i in 1:length(x)){
    z[i] <- x[i] + y[i]
  }
  ##return the result
  return(z)
}

##addition of two vectors
non_vec_addition(vec_1, vec_2)

##two long vectors
long_vec_1 <- runif(10000000, 0, 1)
long_vec_2 <- runif(10000000, 0, 1)

##time the non-vectorised vs vectorised approaches
system.time({
  non_vec_addition(long_vec_1, long_vec_2)
  })

system.time({
  long_vec_1+long_vec_2
  })

# 2.3.2 Practically, what does this mean?

library(data.table)

##make a blank list
save_data <- vector(mode = "list",
                    length = length(unique(iris$Species)))

##add some additional data to to the iris data frame
for(o in 1:length(unique(iris$Species))){
  ##subset the full data set, making a new subset for each species in turn
  sub <- subset(iris, Species==unique(iris$Species)[o])

  ##add in a new column called "outlier"
  ##we will use this to identify possible outliers in the data
  ## we initially fill this with NAs
  sub$outlier <- NA
  ##then if the subset data is from the species "versicolor"...
  if(sub$Species[1]=="versicolor"){
    ##...and the value of the Petal.Length column is greater than 5
    ## then save an "outlier" not in the outlier column
    sub$outlier[which(sub$Petal.Length > 5)] <- "outlier"
  }
  ##add the data to our blank list
  save_data[[o]] <- sub
}

##bind the list togehter (using rbindlist from the data.table package)
save_data <- rbindlist(save_data)

##see if it worked:
filter(save_data, Species == "versicolor", Petal.Length > 5)

# improve code in vector format

iris$outlier <- NA
iris$outlier[iris$Petal.Length >5 & iris$Species=="versicolor"] <- "outlier"
iris

x <- runif(10, 0, 1)

for(h in 1:length(x)){
  ##calculate the sum of the standard deviation of x
  sd_x <- sum(sd(x))

  ##define a constant
  cons <- 3.1512

  ##add to the h'th item in x:
  x[h] <- x[h] + sd_x + cons
}

##calculate the sum of the standard deviation of x
sd_x <- sum(sd(x))
##define a constant
cons <- 3.1512
for(h in 1:length(x)){
  ##add to the h'th item in x:
  x[h] <- x[h] + sd_x + cons
}
h

# 2.5 Defining functions inside functions

# don't do this

##define a function first
my_func <- function(x, y){

  ##define a second function
  my_second_func <- function(x){
    return(x^3)
  }

  ##run the new function
  new_x <- my_second_func(x)

  ##return the new values
  return(list(new_x, y))
}

# do this

##define a second function
my_second_func <- function(x){
  ##return a new value for x
  return(x^3)
}

##define a function first
my_func <- function(x, y){

  ##run the new function
  new_x <- my_second_func(x)

  ##return the new values
  return(list(new_x, y))
}

# 2.6 Pre allocating memory

##a blank object
results <- NULL

##a sequence to loop along
loop_nums <- 1:2000000

##time the loop
system.time({
  ##run a loop
  for(j in loop_nums){
    ##do a calculation
    calc <- sin(j + (j^2))

    ##bind out the results
    results[[j]] <-calc
  }
})

# Pre-allocated code version of previous code

##a sequence to loop along
loop_nums <- 1:2000000

##a blank list of length loop nums
better_results <- vector(mode = "list",
                         length = length(loop_nums))

##time the loop
system.time({
  for(j in loop_nums){
    ##do a calculation
    calc <- sin(j + (j^2))

    ##bind out the results
    better_results[[j]] <- calc
  }
})


# 2.7 Parallelisation

## load the deSolve package for solving
## differential equations
library(deSolve)

## define a three species LV models
lv2 <- function(t, start, parms) {
    ##set the start values for each of the species
    ##basal species
    R <- start["R"]
    ## consumers
    N <- start["N"]

    ##allow R to look within parms for the values of r, a, e, etc
    with(as.list(parms), {
        ## dynamics of the resources
        dR <- r*R - a*N*R
        ## dynamics of the primary consumers
        dN <- f*a*N*R - q*N
        ##return a list of the abundances of each species
        ##deSolve will then group these into a data frame
        list(c(dR, dN))
    })
}

##we will pass these two functions tell to the ODE solver
##to tell it to set the abundance of either species to 0
##if the simulated abundance falls to less than 0 individuals
##i.e. we will simulate extinction of the species otherwise
##we will have some abundance values which are very very small
##and very very large
eventFun<-function(t,y,p){
  y <- c(0, 0)
  return (y)
}
rootfun <- function (t,y,p) {
  if(min(y)<1){
    y <- c(0, 0)
  }
  return(y)
}

##we will then put the above function into a wrapper function which includes
##the ODE solver function and some data reshaping and saving out parameter combinations:
lv2_sim <- function(start, parms, time){
  ##run the simulation
  sim <- as_tibble(lsoda(y = start,
                          times = time,
                          func = lv2,
                          parms = parms,
                          ##pass the event function
                          events = list(func = eventFun,
                                       ##yes we want to use a root
                                       ##function
                                       root = TRUE,
                                       ##tell lsoda to stop the
                                       ##simulation if the event
                                       ##is triggered
                                       terminalroot = 1),
                          ##and the root function
                          rootfun = rootfun))

  ##reshape the data to long format:
  longer_sim <- sim %>% pivot_longer(-time,
                                      values_to = "abundance",
                                      names_to="species")
  ##number of years the time series ran for:
  longer_sim$sim_length<-max(longer_sim$time)

  ##add a column to allow us to easily split the results up later
  longer_sim$parms <- paste(names(parms), parms, sep="=", collapse = ",")

  ##make a list of the simulation results and the
  ##parameters which made them
  res <- list("sim" = longer_sim,
              "parameters" = parms)
  return(res)
}

##make an object of the parameters of the model
##we will pass this to the ODE solver
parms <- c(r = 0.1,     #growth rate of resources
           a = 0.01,        #feeding rate of primary consumer on resources
           f = 0.01,        #efficinecy of feeding on resources
           q = 0.1      #intrinsic death rate of the primary consumer
           )

#define the parameters
start <- c(R = 100,
           N = 10)

##set the length of the simulation (100 time steps)
## and the resolution (set size, in this case 0.1 time steps)
time <- seq(0, 100, 1)

##run the simulation
dd <- lv2_sim(start, parms, time)

##plot it
ggplot(dd$sim, aes(x=time, y=abundance, col=species)) +
  geom_line() +
  scale_y_log10() +
  theme_minimal()

##make a list where the sequence 0.01 to 1 is
##replicated once for each of the parameters in parms
parms_list <- rep(list(seq(0.01, 0.2, length.out = 5)),
                  length(parms))

##use expand.grid() to make a data.frame of every possible
##combination of the 8 parameters
all_var <- expand.grid(parms_list)

##look at the data
head(all_var)

## the dimensions of the data
dim(all_var)

##convert that into a list, where each object is 1 row of the data frame
all_var_list <- as.list(as.data.frame(t(all_var)))

##save out the time it takes to run
time_single_core <- system.time({
      ##the simulations
      res <- lapply(all_var_list, function(x, name_vars, start, time){
        try({
              ##add names to the parameters selected from the list
              names(x)<-name_vars
              ##pass the arguments to the function and run the simulation
              dd <- lv2_sim(start = start,
                            parms = x,
                            time = time)
              ##return the data we want:
              return(dd)
        }, silent = TRUE)
            ##any additional objects we want to pass to lapply
            ## listed between the last }  and the last )
            },  name_vars = names(parms),
                start = start,
                time = time)
  })
##how long did it take?
time_single_core

library(parallel)
##show the number of cores
n_cores <- detectCores()
n_cores

##save the time out
time_multi_core <- system.time({
      ##run the simulations
      res <- mclapply(all_var_list, function(x, name_vars, start, time){
        try({
              ##add names to the parameters selected from the list
              names(x) <- name_vars
              ##pass the arguments to the function and run the simulation
              dd <- lv2_sim(start = start,
                            parms = x,
                            time = time)
              ##return the data we want:
              return(dd)
        })
            ##any additional objects we want to pass to lapply
            ## listed between the last }  and the last )
            },  name_vars = names(parms),
                start = start,
                time = time,
                ## here we can specify the number of cores we want to use
                ## I always use n.cores-1 so the computer doesn't slow
                ## down too much
                mc.cores = n_cores - 1)
  })

#divide
time_single_core["elapsed"] / time_multi_core["elapsed"]

##look at the first object of the results
res[[1]]

##bind the results into a data frame
extract_res <- rbindlist(lapply(res, function(h){
  ##extract and return the simulation values
  return(h$sim)
}))

##plot the results
ggplot(extract_res, aes(x = time,
                        y = abundance,
                        group = parms)) +
  geom_line(col = "white", alpha=0.3) +
  facet_wrap(~species) +
  ##log the y axis
  scale_y_log10() +
  ##dark theme
  theme_dark()

# Plot data above but only those which reach 100 time steps

ggplot(filter(extract_res, sim_length == 100),
       aes(x = time,
           y = abundance,
           group = parms)) +
  geom_line(col = "white", alpha=0.4) +
  facet_wrap(~species, scales = "free") +
  ##log the y axis
  scale_y_log10() +
  ##dark theme
  theme_dark()

# 2.7.2 Parallel for() loops

##load the foreach
library(foreach)

##an object to iterate over
our_seq <- 1:3

##Not parallelised
foreach(i = our_seq) %do% {
  ##some calculation
  sin(i/i^2)
}

##load the doSNOW package
library(doSNOW)

##make a cluster, defining the number of cores to use
clus  <- makeCluster(detectCores() - 1)

##register the cluster with doParallel
##you only need to do this once, then you can use it for the rest
##of your script
registerDoSNOW(clus)

##an object to iterate over
our_seq <- 1:30

##then you can run a parallelised version of of our foreach() loop
looped_result <- foreach(i = our_seq) %dopar% {
  sin(i/i^2)
}

##look at the output
head(looped_result)

## combine into a tibble
## see ?rbind for details (hint - it means row bind)
new_tib <- foreach(i = our_seq,
                   .combine = 'rbind',
                   .packages = "tidyverse") %dopar% {
  ##return a tibble object with sin of i
  ##and the value of i
  return(tibble("sin" = sin(i/i^2),
                   "i" = i))
}

## look at new_tib
new_tib

##make a progress bar, we need to set the maximum to the
##maximum length of the sequence we are iterating across
pb <- txtProgressBar(max = max(our_seq), style = 3)

##make a function to pass the progress bar to the clusters
progress <- function(n) setTxtProgressBar(pb, n)
##and set the options for snow to include a progress bar
opts <- list(progress = progress)

##load in the options using .options.snow
new_tib <- foreach(i = our_seq,
                   .combine = 'rbind',
                   .packages = "tidyverse",
                   .options.snow = opts) %dopar% {
  ##return the output
  return(data.frame("sin" = sin(i/i^2),
                   "i" = i))
}
