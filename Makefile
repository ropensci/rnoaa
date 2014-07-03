all: move rmd2md cleanup

move:
		cp inst/vign/rnoaa_vignette.md vignettes;\
		cp inst/vign/rnoaa_attributes.md vignettes;\
		cp inst/vign/erddap_vignette.md vignettes;\
		cp inst/vign/swdi_vignette.md vignettes;\
		cp -r inst/vign/figure/* vignettes/figure

pandoc:
		cd vignettes;\
		pandoc -H margins.sty rnoaa_attributes.md -o rnoaa_attributes.pdf --highlight-style=tango;\
		pandoc -H margins.sty rnoaa_attributes.md -o rnoaa_attributes.html --highlight-style=tango
		# pandoc -H margins.sty erddap_vignette.md -o erddap_vignette.html --highlight-style=tango
# 		pandoc -H margins.sty rnoaa_vignette.md -o rnoaa_vignette.pdf --highlight-style=tango;\
# 		pandoc -H margins.sty rnoaa_vignette.md -o rnoaa_vignette.html --highlight-style=tango;\

rmd2md:
		cd vignettes;\
		cp rnoaa_vignette.md rnoaa_vignette.Rmd;\
		cp rnoaa_attributes.md rnoaa_attributes.Rmd;\
		cp erddap_vignette.md erddap_vignette.Rmd;\
		cp swdi_vignette.md swdi_vignette.Rmd

cleanup:
		cd vignettes;\
		rm rnoaa_vignette.md rnoaa_attributes.md erddap_vignette.md swdi_vignette.md
