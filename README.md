#scalbf_evaluation

A Docker image to evaluate modifications in the R packages [bfast](https://r-forge.r-project.org/projects/bfast/) [1] and [strucchange](https://cran.r-project.org/web/packages/strucchange/index.html) [2] within the SCALBF project. The docker image runs the same functions using original CRAN and modified versions of the packages (see [here](https://github.com/appelmar/strucchange) and [here](https://github.com/appelmar/bfast) ) and compares results, computation times and achieved speedup factors. 

## Getting Started

1. Clone this repository and change to its root directory `git clone https://github.com/appelmar/scalbf_evaluation && cd scalbf_evaluation`.

2. Build the docker image e.g. with `sudo docker build --tag "scalbf_evaluation"  .`

3. Run a container e.g. with `sudo docker run --rm -v $PWD/results:/opt/results scalbf_evaluation`. Sharing the results directory makes sure that results are accessible after completion. This step might take some time.

4. New HTML reports `report_test_*.html`,  `report_benchmark_*.html` and `report_profiling_*.html` have been generated in the results directory. These reports contain a comparison of computation times, present achieved speedups, and identify computational bottlenecks respectively.


## Details
The image can be used to

- test (make sure that the modified R packages achieve the same results),
- benchmark (compare computation times and speedup factors), and
- profile (identify potential computational bottlenecks)

the packages. By default, all of the three operations each generate an html report using RMarkdown. If you want to perform only one or two 
of testing, benchmarking, and profiling, you may either change the `CMD` statement in `Dockerfile`, or overriding CMD in `docker run` with e.g. `sudo docker run -v $PWD/results:/opt/results scalbf_evaluation test`


### Adding test functions
The R script files `test.R` and `benchmark.R` contain a set of R functions each. These functions are automatically executed using original versions first and modified packages afterwards. While functions `test.R` are only compared for correctness, functions in `benchmark.R` are used for benchmarking and profiling. You may add functions in these files if you want to run and analyze your own function. 


### Comparing specific git commits
If you do not want to compare the latest modifications with the original CRAN versions, you can change `github_vars.sh` and specify hashed commit identifier to use. This can be used e.g. to track the effect on computaiton times of single commits. 

### Using local package versions
If you don't want to compare github version, you can copy local package directories `bfast` and `strucchange` to files and add `local` to the `docker run` command.


## Dependencies

- [Docker](https://www.docker.com/) 


## References

[1] Verbesselt J, Zeileis A, Herold M (2012). Near real-time disturbance detection using satellite image time series. Remote Sensing of Environment, 123, 98–108.

[2] Zeileis, A., Leisch, F., Hornik, K., & Kleiber, C. (2002). strucchange: An R Package for Testing for Structural Change in Linear Regression Models. Journal of Statistical Software, 7(2), 1 - 38. doi:http://dx.doi.org/10.18637/jss.v007.i02

## Author(s)
Marius Appel <marius.appel@uni-muenster.de>


