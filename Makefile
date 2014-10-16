all: move rmd2md cleanup

move:
		cp inst/vign/ncdc_vignette.md vignettes;\
		cp inst/vign/ncdc_attributes.md vignettes;\
		cp inst/vign/ncdc_workflow.md vignettes;\
		cp inst/vign/erddap_vignette.md vignettes;\
		cp inst/vign/swdi_vignette.md vignettes;\
		cp inst/vign/seaice_vignette.md vignettes;\
		cp inst/vign/homr_vignette.md vignettes;\
		cp inst/vign/storms_vignette.md vignettes;\
		cp -r inst/vign/figure/* vignettes/figure

rmd2md:
		cd vignettes;\
		cp ncdc_vignette.md ncdc_vignette.Rmd;\
		cp ncdc_attributes.md ncdc_attributes.Rmd;\
		cp ncdc_workflow.md ncdc_workflow.Rmd;\
		cp erddap_vignette.md erddap_vignette.Rmd;\
		cp seaice_vignette.md seaice_vignette.Rmd;\
		cp swdi_vignette.md swdi_vignette.Rmd;\
		cp homr_vignette.md homr_vignette.Rmd;\
		cp storms_vignette.md storms_vignette.Rmd

cleanup:
		cd vignettes;\
		rm ncdc_vignette.md ncdc_attributes.md ncdc_workflow.md erddap_vignette.md swdi_vignette.md seaice_vignette.md homr_vignette.md storms_vignette.md
