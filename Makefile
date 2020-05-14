# build package and documentation
sanapiwrapper.pdf: R/sanapiwrapper.R
	R -e 'devtools::build()'
	R -e 'devtools::install()'
	R -e 'devtools::check()'
	R -e 'devtools::test()'
	R -e 'devtools::document()'
	R -e 'devtools::build_manual()'
	rm -f man/*.pdf
	cp ../sanapiwrapper*.pdf man/sanapiwrapper.pdf
