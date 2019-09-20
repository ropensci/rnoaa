RSCRIPT = Rscript --no-init-file

all: move rmd2md

move:
		cp inst/vign/ncdc_vignette.md vignettes;\
		cp inst/vign/ncdc_attributes.md vignettes;\
		cp inst/vign/ncdc_workflow.md vignettes;\
		cp inst/vign/swdi_vignette.md vignettes;\
		cp inst/vign/seaice_vignette.md vignettes;\
		cp inst/vign/homr_vignette.md vignettes;\
		cp inst/vign/storms_vignette.md vignettes;\
		cp inst/vign/buoy_vignette.md vignettes;\
		cp inst/vign/rnoaa_ropenaq.md vignettes;\
		cp -r inst/vign/figure/* vignettes/figure

rmd2md:
		cd vignettes;\
		mv ncdc_vignette.md ncdc_vignette.Rmd;\
		mv ncdc_attributes.md ncdc_attributes.Rmd;\
		mv ncdc_workflow.md ncdc_workflow.Rmd;\
		mv seaice_vignette.md seaice_vignette.Rmd;\
		mv swdi_vignette.md swdi_vignette.Rmd;\
		mv homr_vignette.md homr_vignette.Rmd;\
		mv storms_vignette.md storms_vignette.Rmd;\
		mv buoy_vignette.md buoy_vignette.Rmd;\
		mv rnoaa_ropenaq.md rnoaa_ropenaq.Rmd

revdep:
	${RSCRIPT} -e "revdepcheck::revdep_reset(); revdepcheck::revdep_check()"

install: doc build
	R CMD INSTALL . && rm *.tar.gz

build:
	R CMD build .

doc:
	${RSCRIPT} -e "devtools::document()"

eg:
	${RSCRIPT} -e "devtools::run_examples()"

check:
	${RSCRIPT} -e "devtools::check(document = FALSE, cran = TRUE)"

test:
	${RSCRIPT} -e "devtools::test()"

pkgdocs:
	${RSCRIPT} -e "pkgdown::build_site()"
