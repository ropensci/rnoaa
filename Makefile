PACKAGE := $(shell grep '^Package:' DESCRIPTION | sed -E 's/^Package:[[:space:]]+//')
RSCRIPT = Rscript --no-init-file

vign:
	cd vignettes;\
	${RSCRIPT} -e "Sys.setenv(NOT_CRAN='true'); knitr::knit('rnoaa.Rmd.og', output = 'rnoaa.Rmd')";\
	cd ..

vign_ncdc:
	cd vignettes;\
	${RSCRIPT} -e "Sys.setenv(NOT_CRAN='true'); knitr::knit('ncdc_vignette.Rmd.og', output = 'ncdc_vignette.Rmd')";\
	cd ..

vign_ncdc_attr:
	cd vignettes;\
	${RSCRIPT} -e "Sys.setenv(NOT_CRAN='true'); knitr::knit('ncdc_attributes.Rmd.og', output = 'ncdc_attributes.Rmd')";\
	cd ..

vign_ncdc_workflow:
	cd vignettes;\
	${RSCRIPT} -e "Sys.setenv(NOT_CRAN='true'); knitr::knit('ncdc_workflow.Rmd.og', output = 'ncdc_workflow.Rmd')";\
	cd ..

vign_swdi:
	cd vignettes;\
	${RSCRIPT} -e "Sys.setenv(NOT_CRAN='true'); knitr::knit('swdi_vignette.Rmd.og', output = 'swdi_vignette.Rmd')";\
	cd ..

vign_seaice:
	cd vignettes;\
	${RSCRIPT} -e "Sys.setenv(NOT_CRAN='true'); knitr::knit('seaice_vignette.Rmd.og', output = 'seaice_vignette.Rmd')";\
	cd ..

vign_homr:
	cd vignettes;\
	${RSCRIPT} -e "Sys.setenv(NOT_CRAN='true'); knitr::knit('homr_vignette.Rmd.og', output = 'homr_vignette.Rmd')";\
	cd ..

vign_buoy:
	cd vignettes;\
	${RSCRIPT} -e "Sys.setenv(NOT_CRAN='true'); knitr::knit('buoy_vignette.Rmd.og', output = 'buoy_vignette.Rmd')";\
	cd ..

vign_ropenaq:
	cd vignettes;\
	${RSCRIPT} -e "Sys.setenv(NOT_CRAN='true'); knitr::knit('rnoaa_ropenaq.Rmd.og', output = 'rnoaa_ropenaq.Rmd')";\
	cd ..

revdep:
	${RSCRIPT} -e "revdepcheck::revdep_reset(); revdepcheck::revdep_check()"

install: doc build
	R CMD INSTALL . && rm *.tar.gz

build:
	R CMD build .

doc:
	${RSCRIPT} -e "devtools::document()"

eg:
	${RSCRIPT} -e "devtools::run_examples(run = TRUE)"

check: build
	_R_CHECK_CRAN_INCOMING_=FALSE R CMD CHECK --as-cran --no-manual `ls -1tr ${PACKAGE}*gz | tail -n1`
	@rm -f `ls -1tr ${PACKAGE}*gz | tail -n1`
	@rm -rf ${PACKAGE}.Rcheck

check_windows:
	${RSCRIPT} -e "devtools::check_win_devel(); devtools::check_win_release()"

test:
	${RSCRIPT} -e "devtools::test()"

readme:
	${RSCRIPT} -e "knitr::knit('README.Rmd')"
