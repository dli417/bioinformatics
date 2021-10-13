# Create an array containing 100 random numbers drawn from a uniform
# distribution (see runif()) with at least 3 groups. Consider the limitations
# in terms of the dimensions you can specify given the length of the data you
# are adding to the matrix.

array(runif(100, 69, 420), dim = c(5, 5, 4))
