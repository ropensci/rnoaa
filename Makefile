all: move pandoc rmd2md

move:
		cp inst/vign/rnoaa_vignette.md vignettes;\
		cp inst/vign/rnoaa_attributes.md vignettes;\
		cp -r inst/vign/figure/* vignettes/figure

pandoc:
		cd vignettes;\
		pandoc -H margins.sty rnoaa_vignette.md -o rnoaa_vignette.pdf --highlight-style=tango;\
		pandoc -H margins.sty rnoaa_vignette.md -o rnoaa_vignette.html --highlight-style=tango;\
		pandoc -H margins.sty rnoaa_attributes.md -o rnoaa_attributes.pdf --highlight-style=tango;\
		pandoc -H margins.sty rnoaa_attributes.md -o rnoaa_attributes.html --highlight-style=tango

rmd2md:
		cd vignettes;\
		cp rnoaa_vignette.md rnoaa_vignette.Rmd;\
		cp rnoaa_attributes.md rnoaa_attributes.Rmd
