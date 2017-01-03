FROM ubuntu:14.04

MAINTAINER Marius Appel <marius.appel@uni-muenster.de>

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
RUN echo "deb http://cran.rstudio.com/bin/linux/ubuntu trusty/" >> /etc/apt/sources.list 
RUN  apt-get -qq update && apt-get install -qq --fix-missing -y --force-yes r-base r-base-dev git openssl libcurl4-openssl-dev  wget apt-transport-https gdebi

RUN wget https://github.com/jgm/pandoc/releases/download/1.18/pandoc-1.18-1-amd64.deb
RUN yes | gdebi pandoc-1.18-1-amd64.deb

RUN Rscript --vanilla -e 'install.packages(c("devtools","knitr","rmarkdown","forecast", "sp", "raster","igraph","microbenchmark"),repos="http://cloud.r-project.org")'

RUN Rscript --vanilla -e 'devtools::install_github("hadley/lineprof")'


COPY files /opt/files

WORKDIR /opt/files

RUN chmod +x run.sh github_vars.sh

ENTRYPOINT ["./run.sh"]
CMD  ["test","benchmark","profile"]
