# sanapiwrapper

Wrapper of the [GraphQL](https://graphql.org) based [Santiment API](https://neuro.santiment.net). 

## installation

First install the following R packages by hand.
```
install.packages(c("devtools", "roxygen2", "jsonlite", "tidyr", "testthat"))

library(devtools)
install_github("ropensci/ghql")
```
Download the `tar.gz` file and run on the command line.
```
R CMD INSTALL sanapiwrapper_0.2.tar.gz
```
Alternatively, clone the repository and run the make file.
```
git clone https://github.com/josefansinger/sanapiwrapper.git
cd sanapiwrapper
make
```

## usage

```
library(sanapiwrapper)

metric <- santimentMetric('daily_active_addresses', 'ethereum', '2020-01-01', '2020-04-01')
```

Examples are listed in the [documentation](https://github.com/josefansinger/sanapiwrapper/blob/master/man/sanapiwrapper_0.2.pdf). Further [tests](https://github.com/josefansinger/sanapiwrapper/tree/master/tests/testthat) are run during the build process.


[![Travis build status](https://travis-ci.com/josefansinger/sanapiwrapper.svg?branch=master)](https://travis-ci.com/josefansinger/sanapiwrapper)
