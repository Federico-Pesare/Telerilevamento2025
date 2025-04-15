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




#########################################
mf <- function(x,y){
  par(mfrow=c(x,y))
  }

tfun <- function(x,y) {
  z=x+y
  return(z)
  }

numbering <- function(x){
if(x>0){
  print("Positive number")
  }
else if(x==0)
  {
  print("Hey, don't miss around. Zero is nor negative nor positive okkkkk?????")
  }
else if(x<0)
  {
  print("Negative number")
  }
}
