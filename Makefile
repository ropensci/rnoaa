all: move rmd2md cleanup

knit:
	Rscript --vanilla -e 'library(knitr); setwd("inst/vign"); knit("ncdc_vignette.Rmd"); knit("ncdc_workflow.Rmd"); knit("ncdc_attributes.Rmd")'

move:
		cp inst/vign/ncdc_vignette.md vignettes;\
		cp inst/vign/ncdc_attributes.md vignettes;\
		cp inst/vign/ncdc_workflow.md vignettes;\
		cp inst/vign/erddap_vignette.md vignettes;\
		cp inst/vign/swdi_vignette.md vignettes;\
		cp inst/vign/seaice_vignette.md vignettes;\
		cp inst/vign/buoy_vignette.md vignettes;\
		cp -r inst/vign/figure/* vignettes/figure

pandoc:
		cd vignettes;\
		pandoc -H margins.sty ncdc_attributes.md -o ncdc_attributes.pdf --highlight-style=tango;\
		pandoc -H margins.sty ncdc_attributes.md -o ncdc_attributes.html --highlight-style=tango
		# pandoc -H margins.sty erddap_vignette.md -o erddap_vignette.html --highlight-style=tango
# 		pandoc -H margins.sty ncdc_vignette.md -o ncdc_vignette.pdf --highlight-style=tango;\
# 		pandoc -H margins.sty ncdc_vignette.md -o ncdc_vignette.html --highlight-style=tango;\

rmd2md:
		cd vignettes;\
		cp ncdc_vignette.md ncdc_vignette.Rmd;\
		cp ncdc_attributes.md ncdc_attributes.Rmd;\
		cp ncdc_workflow.md ncdc_workflow.Rmd;\
		cp erddap_vignette.md erddap_vignette.Rmd;\
		cp seaice_vignette.md seaice_vignette.Rmd;\
		cp swdi_vignette.md swdi_vignette.Rmd;\
		cp buoy_vignette.md buoy_vignette.Rmd

cleanup:
		cd vignettes;\
		rm ncdc_vignette.md ncdc_attributes.md ncdc_workflow.md erddap_vignette.md swdi_vignette.md buoy_vignette.md
