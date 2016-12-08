args = commandArgs(trailingOnly=TRUE)

if (length(args) != 1) {
  stop("Output filename argument missing.")
}
if (class(args[1]) != "character") {
  stop("Provided output filename is not a character.")
}
outfile = args[1]

test.env = new.env()
source("test.R", local = test.env )

# find all functions in environment
fs = names(which(sapply(ls(test.env), function(x) {return(class(get(x, envir = test.env)))}) == "function"))


results = list()

for (i in 1:length(fs))
{
  cat(paste("Running ", fs[i], "() ...\n", sep=""))
  f = get(fs[i],envir = test.env)
  results[[fs[i]]] = f()
}
save(results,file = outfile)

