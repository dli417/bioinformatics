# var1 <- c(1, 2, 3, 4)
# var1[1]

# var2 <- c(c(1, 4, 2, 1, 7), c(3, 2))
# var2

##where the first argument is the data to be included in the matrix.
##Here we are using the seq() function which generates regular sequences (see ?seq() for more information)
##and the second and third arguments specify the shape of the matrix (number of columns, and number of rows).
matrix(seq(from = 1, to = 6, by = 1), ncol = 3, nrow = 2)

##creating a blank matrix full of NAs
matrix(NA, ncol = 3, nrow = 4)

matrix(NaN, ncol = 3, nrow = 4)

b <- seq(from = 1, to = 6, by = 1)

##set the dimensions of the matrix (nrows and then ncolumns)
dim(b) <- c(2, 3)

##look at the matrix
b

1:6

dim(matrix(1:6, ncol = 3, nrow = 2))

matrix(1:6, ncol = 3, nrow = 2)

# return value 5 from vector
seq(from = 1, to = 10, by = 1)[5]

##make a matrix and look at it
our_matrix <- matrix(6:1, ncol = 3, nrow = 2)
our_matrix

##return the value of the matrix in the first row and the second column
our_matrix[1, 2]

##return the values in the first row from the first and second column:
our_matrix[1,c(1,2)]

##return the values in the first row
our_matrix[1,]

##return the values in the second column
our_matrix[,2]


## a matrix of values:
init_mat <- matrix(1:6, ncol=3, nrow=2)

##add 1 to all of the values
init_mat <- init_mat+1; init_mat

##Make a matrix. Here we are using rep() to replicate the numbers 1, 2, and 3 five times. 
##Trying running: rep(1:3, each = 5)
##We are then filling our matrix "byrow =TRUE" - which you can see makes a matrix 
mat_rep <- matrix(rep(1:3, each = 5), nrow = 3, ncol = 5, byrow = TRUE)
mat_rep

mat_rep2 <- matrix(rep(1:3, each = 5), nrow = 5, ncol = 3, byrow = TRUE); mat_rep2


## a vector of the numbers 1 to 5
vec_seq <- 1:5

##multiple the matrices using element-wise multiplication
mat_rep * vec_seq

# True matrix multiplication

##where the first argument is the data to be included in the matrix, and the second and third arguments specify the shape of the matrix. 
mat_seq <- matrix(seq(from = 1, to = 20, length.out = 6), ncol = 3, nrow = 2)

##a vector to multiply by
vec_seq <- seq(from = 10, to = 4, length.out = 3)

##multiple the matrices using element-wise multiplication
mat_seq %*% vec_seq
mat_seq
vec_seq

mat_seq %*% mat_seq

##make a matrix
mat_seq <- matrix(seq(1, 20, length.out = 6), ncol = 3, nrow = 2)

## display the logical operator of this matrix for values greater than 10
mat_seq > 10

##return the values which are greater than 10
mat_seq[mat_seq > 10]


seq(1, 20, length.out = 6)

diag(1:5)
x <- matrix(1:9, ncol = 3, nrow = 3)
x
diag(x)
colSums(x)
rowSums(x)


# 2.2 Arrays
this_is_an_array <- array(1:24, dim = c(3, 4, 2))
this_is_an_array

still_an_array <- array(1:24, dim = c(3, 2, 2, 4))
dim(still_an_array)
still_an_array

# 2.3 Data frames

# make a data frame with information on whether a Species was seen (1 = yes,
# 0 = no), on a particular Day:
our_data <- data.frame("Day" = rep(1:3, each = 3),
                       "Species" = rep(letters[1:3], each = 3),
                       "Seen" = rbinom(n = 9, size = 1, prob = 0.5))

##look at the Day column
our_data["Day"]
our_data["Species"]
our_data[1, 2]
our_data
our_data$location <- "United Kingdom"


## some simple data
simple_data  <- data.frame( "a" = runif(10, 0, 1),
                            "b" =  rnorm(10, 3, 5))

## example calculations
simple_data$calc <- (simple_data$a * simple_data$b) - simple_data$b
simple_data


# 2.4 Lists

##make a numeric matrix
num_mat <- matrix(rep(1:3, each = 5), 
                  nrow = 3, 
                  ncol = 5, 
                  byrow = TRUE)

##and a vector of letters
let_vec <- LETTERS[4:16]

##and a data.frame of species information:
species_dat <- data.frame("Species" = c("a", "b"), 
                          "Observed" = c(TRUE, FALSE)) 

##save them into a list using the list() function
our_list <- list(num_mat, 
                 let_vec,
                 species_dat, 
                 5)

##view the list
our_list

##the first object
our_list[[1]]

##extract the first row of the 3rd object in the list:
our_list[[3]][1, ]

our_list[[3]][1]

##save them into a list using the list() function with names
our_list <- list("numbers_vec" = num_mat, 
                 "letters" = let_vec,
                 "spp_pres" = species_dat, 
                 "number" = 5)

##display the names of the objects:
names(our_list)

##view the list
our_list$spp_pres

##make a new list with "data" split into two different sites - site 1 and site 2:
our_second_list <- list("site_1" = our_list,
                        "site_2" = our_list)

##display the list
our_second_list

##letters in site 1
our_second_list$site_1$letters

# 3.1 Packages

##use the install packages function to install the package "devtools" which we
# will use in a moment. dependencies = TRUE tells R to install any other
# packages that devtools relies on which you haven't already installed (I would
# always suggest keeping dependencies = TRUE when you are installing packages)
install.packages("devtools", dependencies = TRUE)

##load the devtools package
library("devtools")

# 3.2 Packages on GitHub
##install the "vroom" package
##The arguement for install_github takes the username and repository name where the package resides 
##if we look at the vroom url: https://github.com/r-lib/vroom
##you can see that we just use the bit after github.com/:
install_github("r-lib/vroom")

# 3.3 Specifying functions from a specific package

## tell R to use the "vroom()" function from the vroom package (see below)
vroom::vroom()

# 4 Loading data into R
# 4.1 .csv files

# 4.1.1 Loading from your local computer
##make sure vroom is loaded into your R session (you only need to do this once)
library(vroom)

##read in the wader data set
wad_dat <- vroom("/Users/danielli/OneDrive\ -\ University\ of\ Bristol/Documents/Bioinformatics/Coursework/Programming\ in\ R/Week\ 3/wader_data.csv")

##look at the top of the data
head(wad_dat)

##first we set the working directory (which is the location of the current file you are working on):
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

##then read in the data using vroom:
wad_dat <- vroom("../../data/Workshop 3/wader_data.csv")

head(wad_dat)

covid_dat <- vroom("../../data/Workshop 3/time_series_covid19_deaths_global.csv")

head(covid_dat)

# 4.1.2 Loding from GitHub
##use vroom to read in some data from github:
covid_dat <- vroom("https://raw.githubusercontent.com/chrit88/Bioinformatics_data/master/Workshop%203/time_series_covid19_deaths_global.csv")

# 4.1.2.1 Loading multiple files
##you can ignore this code for the moment if you want
##but to briefly summarise it is reading in some data included in base R
##and then splitting it into 3 differnt data.frame style objects based on the values in one of the columns ("cyl")
mt <- tibble::rownames_to_column(mtcars, "model")
purrr::iwalk(
  split(mt, mt$cyl),
  ##save this split files in to the default directory
  ~ vroom_write(.x, glue::glue("mtcars_{.y}.csv"), "\t")
)
mt

##find files in the default directory which start with "mtcars" and end in "csv"
##save these file names as an object called "files"
files <- fs::dir_ls(glob = "mtcars*csv")

##these are then the names of the files matching the above arguments:
files

##then load these file names using vroom
vroom(files)

# 4.2 RData
##load in some RData
load("my_data/pathway/my_data.RData")

# 5 Writing data out of R
# 5.1 .csv

##write out a .csv file
vroom_write(my_data, "a pathway/a data folder/the_name_of_my_data.csv")

# 5.2 RData

##write out my data as an RData file:
save(my_data, file = "a pathway/a data folder/the_name_of_my_RData.RData")
##write out my data as an RData file:
save(my_data,
     my_vector,
     my_list,
     my_array,
     file = "a pathway/a data folder/the_name_of_my_RData.RData")

# 6 Data handling

# 6.1 Package options
# 6.1.1 The tidyverse

##install the tidyverse
install.packages("tidyverse")

##load the tidyverse
library("tidyverse")

# 6.1.2 Pipelines

my_data %>% function_1() %>% function_2()

# data.table


# 6.2 Summarising data

# run commands to import covid_dat and wad_dat, and load vroom and tidyverse

##what class is the object
class(covid_dat)

##look at the data
covid_dat

##change the first two names of our data frame
names(covid_dat)[1:2] <- c("Province.State", "Country.Region")

# 6.3 Basic data reshaping with pivot_

##so this says take our data frame called covid_dat
covid_long <- covid_dat %>%
                ##and then apply this function 
                pivot_longer(cols = -c( Province.State, 
                                        Country.Region, 
                                        Lat, 
                                        Long))

covid_long

##our data frame
covid_long <- covid_dat %>%
                ##and then apply this function 
                pivot_longer(cols = -c(Province.State:Long),
                             names_to = "Date",
                             values_to = "Deaths")

covid_long

##change long to wide
covid_long %>% 
  pivot_wider(names_from = Date,
              values_from = Deaths)

covid_long

# Key concepts
# Matrices - 2 dimensions containing a single type of data
# Arrays are n dimensional matrices containing a single type of data
# data.frames (including tibble) can contain multiple data types
# Lists - structures containing nested information of multiple types
# Installing packages from CRAN via `install.packages(“package.name”)
# Installing packages from Github via install_github("r-lib/vroom")
# We can specify a function to be used from a certain package using the :: operator: vroom::vroom()
# Load data into R using vroom() via direct pathways, or using a relative pathway
# Load data from Github using vroom() and the data url
# Creating pipelines via the magrittr operator %>%
# Reshaping data from wide to long and long to wide using the pivot_ functions

