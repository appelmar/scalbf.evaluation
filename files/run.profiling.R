args = commandArgs(trailingOnly=TRUE)

library(lineprof)

if (length(args) != 1) {
  stop("Output filename argument missing.")
}
if (class(args[1]) != "character") {
  stop("Provided output filename is not a character.")
}
outfile = args[1]

test.env = new.env()
source("benchmark.R", local = test.env )


# find all functions in environment
fs = names(which(sapply(ls(test.env), function(x) {return(class(get(x, envir = test.env)))}) == "function"))


results = list()
results_prof = list()

for (i in 1:length(fs))
{
  cat(paste("Running ", fs[i], "() ...\n", sep=""))
  f = get(fs[i],envir = test.env)
  lprof = lineprof(f(),interval = 0.005)
  
  ftest = c("model.frame","cumsum","computeEmpProc","extend.RSS.table","RSS","RSSi","extract.breaks", "computeEstims","root.matrix", "crossprod", "border","model.response","model.matrix","outer","as.character","factor","as.ts","ts","%*%","as.vector","as.matrix","lm","lm.fit",
            unique(c(ls(envir = environment(bfast::bfast)), ls(envir = environment(strucchange::monitor)))))

  results_prof[[fs[i]]] = lprof
  res = data.frame(f=ftest, time=rep(NA,length(ftest)))
  res$time = sapply(ftest,function(y) { sum(focus(lprof, y)$time)},simplify = "array")
  res = res[order(res$time,decreasing = T),]
  res = res[which(res$time > 0),]
  res = rbind(data.frame(f="(TOTAL)",time=sum(lprof$time)), res)
  res$rel_time = res$time / res$time[1]

  results[[fs[i]]] = res
}

save(results,results_prof,file = outfile)

