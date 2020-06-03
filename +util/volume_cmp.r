#if (require('volesti')) {
#    library(volesti)
#} else {
#    warning('Installing volesti')
#    install.packages('volesti')
#    library(volesti)
#}
require('volesti')


path = "c:/Users/Timon/OneDrive - Danmarks Tekniske Universitet/Denmark/DTU/2019_20_II/software/polytope_"
ext = ".csv"
n <- 0:100
V <- numeric(length = length(n))


for (i in seq_along(n)) {
    N <- n[i]*100
    paste(c(path,N), collapse="")
    A <- read.csv(paste(c(path,"A_",N,ext), collapse=""), sep=",", header=FALSE)
    A <- as.matrix(A)
    b <- read.csv(paste(c(path,"b_",N,ext), collapse=""), sep=",", header=FALSE)
    b <- as.matrix(b)
    P <- Hpolytope$new(A,b)
    
    old <- Sys.time()
    V[i] <- volume(P)
    new <- Sys.time() - old
    print(new)
    print(N)
	
}

write.csv(V, paste(c(path,"volumes.csv"), collapse=""))