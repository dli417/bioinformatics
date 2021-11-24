# Exercice 1.1
# Write a function called help that when executed prints a message (“Help”).
help <- function() {
  print("Help")
}

help()

# Exercice 1.2
# Create a function that given a vector random_vector and an integer will return how many times that integer appears inside the vector.

random_vector <- c(8,9,9,8,5,1,8,5,6,2,3,5,9,9,8)

countfun <- function(random_vector, integer) {
    a <- table(random_vector)
    a[names(a)==435]
}