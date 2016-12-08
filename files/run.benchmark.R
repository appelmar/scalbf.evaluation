args = commandArgs(trailingOnly=TRUE)

if (length(args) != 1) {
  stop("Output filename argument missing.")
}
if (class(args[1]) != "character") {
  stop("Provided output filename is not a character.")
}
outfile = args[1]


#library(microbenchmark)
#n.eval = 100 # number of microbenchmark evaluations


test.env = new.env()
source("benchmark.R", local = test.env )

# find all functions in environment
fs = names(which(sapply(ls(test.env), function(x) {return(class(get(x, envir = test.env)))}) == "function"))


results = data.frame(f=NULL, time=NULL)


for (i in 1:length(fs))
{
  cat(paste("Running ", fs[i], "() ...\n", sep=""))
  f = get(fs[i],envir = test.env)
  results = rbind(results, data.frame(f=fs[i],time=system.time(f())[3],row.names = NULL))
}
print(results)

save(results,file = outfile)

