# build package and documentation
sanapiwrapper.pdf: R/sanapiwrapper.R
	R -e 'devtools::build()'
	R -e 'devtools::install()'
	R -e 'devtools::check()'
	R -e 'devtools::test()'
	R -e 'devtools::document()'
	rm -f doc/sanapiwrapper.pdf
	R CMD Rd2pdf --no-preview -o doc/sanapiwrapper.pdf .
