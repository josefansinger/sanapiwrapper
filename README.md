# sanapiwrapper

Wrapper of the [GraphQL](https://graphql.org) based [Santiment API](https://neuro.santiment.net). 

## installation

Best install the following R packages by hand.
```
install.packages("devtools")
install.packages("roxygen2")
install.packages("jsonlite")
install.packages("tidyr")
install.packages("testthat")

library(devtools)
install_github("ropensci/ghql")
```

Then clone the repository and run the make file.
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

Examples are listed in the [documentation](https://github.com/josefansinger/sanapiwrapper/blob/master/doc/sanapiwrapper.pdf). Further [test](https://github.com/josefansinger/sanapiwrapper/tree/master/tests/testthat) are run during the build process.


[![Travis build status](https://travis-ci.com/josefansinger/sanapiwrapper.svg?branch=master)](https://travis-ci.com/josefansinger/sanapiwrapper)
