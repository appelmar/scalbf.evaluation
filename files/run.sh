#!/bin/bash

profiling=false
testing=false
benchmarking=false
local=false

for i in "$@" ; do
    if [[ $i == "profile" ]] ; then
        profiling=true
        break
    fi
done

for i in "$@" ; do
    if [[ $i == "test" ]] ; then
        testing=true
        break
    fi
done


for i in "$@" ; do
    if [[ $i == "benchmark" ]] ; then
        benchmarking=true
        break
    fi
done

for i in "$@" ; do
    if [[ $i == "local" ]] ; then
        local=true
        break
    fi
done

# Install strucchange and bfast from original versions
source github_vars.sh

if [ "$local" = false ] ; then
    # Install reference versions of strucchange and bfast from github
    git clone $GITHUB_STRUCCHANGE_ORIG && cd strucchange && git reset --hard $COMMIT_STRUCCHANGE_ORIG  &&  echo $( git rev-parse HEAD ) > "/opt/git-strucchange-orig.txt" && cd ..
    git clone $GITHUB_BFAST_ORIG && cd bfast && git reset --hard $COMMIT_BFAST_ORIG  &&  echo $( git rev-parse HEAD ) > "/opt/git-bfast-orig.txt" && cd ..
    Rscript -e 'devtools::install_local("strucchange", force=T)' 
    Rscript -e 'devtools::install_local("bfast", force=T)'
fi
if [ "$local" = true ] ; then
    # Install reference versions of strucchange and bfast from CRAN
    Rscript -e 'install.packages("strucchange", repos="http://cran.uni-muenster.de")' 
    Rscript -e 'install.packages("bfast", repos="http://cran.uni-muenster.de")'
fi



# Run scripts and store result as a file
if [ "$testing" = true ] ; then
    Rscript --vanilla run.test.R "/opt/results/test.results.old.rda"
fi
if [ "$benchmarking" = true ] ; then
   Rscript --vanilla run.benchmark.R "/opt/results/benchmark.results.old.rda"
fi
if [ "$profiling" = true ] ; then
    Rscript --vanilla run.profiling.R "/opt/results/profiling.results.old.rda"
fi



if [ "$local" = false ] ; then
  # Install modified strucchange and bfast from github
  rm -Rf strucchange
  rm -Rf bfast
  git clone $GITHUB_STRUCCHANGE_MOD && cd strucchange 
  if [ -z ${COMMIT_STRUCCHANGE_MOD+x} ]; then git reset --hard $COMMIT_STRUCCHANGE_MOD;  fi
  echo $( git rev-parse HEAD ) > "/opt/git-strucchange-mod.txt" && cd ..
  git clone $GITHUB_BFAST_MOD && cd bfast 
  if [ -z ${COMMIT_BFAST_MOD+x} ]; then git reset --hard $COMMIT_BFAST_MOD;  fi
  echo $( git rev-parse HEAD ) > "/opt/git-bfast-mod.txt" && cd ..
fi

Rscript -e 'devtools::install_local("strucchange", args="--preclean", force=T)' 
Rscript -e 'devtools::install_local("bfast", args="--preclean", force=T)'


# Run scripts and store result as a file
if [ "$testing" = true ] ; then
    Rscript --vanilla run.test.R "/opt/results/test.results.new.rda"
fi
if [ "$benchmarking" = true ] ; then
   Rscript --vanilla run.benchmark.R "/opt/results/benchmark.results.new.rda"
fi
if [ "$profiling" = true ] ; then
    Rscript --vanilla run.profiling.R "/opt/results/profiling.results.new.rda"
fi


# Generate reports
if [ "$testing" = true ] ; then
    Rscript --vanilla -e 'rmarkdown::render("report.test.Rmd", output_file=paste("report_test_", format(Sys.time(),"%Y%m%d-%H%M%S"), ".html", sep=""), output_dir="/opt/results")'
fi
if [ "$benchmarking" = true ] ; then
   Rscript --vanilla -e 'rmarkdown::render("report.benchmark.Rmd", output_file=paste("report_benchmark_", format(Sys.time(),"%Y%m%d-%H%M%S"), ".html", sep=""), output_dir="/opt/results")'
fi
if [ "$profiling" = true ] ; then
    Rscript --vanilla -e 'rmarkdown::render("report.profiling.Rmd", output_file=paste("report_profiling_", format(Sys.time(),"%Y%m%d-%H%M%S"), ".html", sep=""), output_dir="/opt/results")'

fi

