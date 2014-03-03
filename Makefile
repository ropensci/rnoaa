all: move pandoc rmd2md

move:
		cp inst/vign/rnoaa_vignette.md vignettes

pandoc:
		cd vignettes;\
		pandoc -H margins.sty rnoaa_vignette.md -o rnoaa_vignette.pdf --highlight-style=tango;\
		pandoc -H margins.sty rnoaa_vignette.md -o rnoaa_vignette.html --highlight-style=tango

rmd2md:
		cd vignettes;\
		cp rnoaa_vignette.md rnoaa_vignette.Rmd