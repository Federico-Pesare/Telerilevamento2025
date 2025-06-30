# Code to create new functions

# a function to do the sum of two numbers
somma <- function(x,y) {
  z=x+y
  return(z)
  }

diff <- function(x,y) {
  z=x-y
  return(z)
  }

# a function to create a multiframe in an easy way
mf <- function(nrow,ncol) {
par(mfrow=c(nrow,ncol))
  }

# a function to know if a number is positive or negative (else significa "tutti gli altri casi")
positivo <- function(x) {
  if(x>0) {
    print("Questo numero è positivo")
    }
  else if(x<0) {
    print("Questo numero è negativo")
    }
  else {
    print("Lo zero è zero")
    }
  }




