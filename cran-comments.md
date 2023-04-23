## Test environments

* windows 10.0.19045 local install, R 4.2.1
* ubuntu-latest (release, on GitHub Actions)
* macOS-latest (release, on GitHub Actions)
* macOS-latest (devel, on GitHub Actions)
* windows-latest (release, on GitHub Actions)
* win-builder (release, devel)

## R CMD check results

0 errors | 0 warnings | 0 notes

## revdepcheck results

We checked 2 reverse dependencies, comparing R CMD check results across CRAN and dev versions of this package.

 * We saw 0 new problems
 * We failed to check 0 packages
 
## Notes

This update is primarily to fix an issue with an S3 generic/method consistency in the function autoplot.meteo_coverage. This was a mistake in the namespace and was not being used as a generic despite the name.

* The argo functions were also dropped because of a recent change to the API that makes it unusable currently
* There were a couple other minor changes to switch tidyverse functions from deprecated functions to the newer equivalents.

Thanks!
Daniel Hocking
