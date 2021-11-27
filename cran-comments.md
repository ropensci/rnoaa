## Test environments

* ubuntu 20.04 (local install), R 4.1.2
* macOS-latest (release, on GitHub Actions), R 4.1.2
* macOS-latest (devel, on GitHub Actions), R-dev
* ubuntu-latest (release, on GitHub Actions), R 4.1.2
* win-builder (release, devel)

## R CMD check results

0 errors | 0 warnings | 0 notes

## revdepcheck results

We checked 2 reverse dependencies (0 from CRAN + 2 from Bioconductor), comparing R CMD check results across CRAN and dev versions of this package.

 * We saw 0 new problems
 * We failed to check 0 packages

-----

This version updates the writing locations to comply with CRAN policy by switching from using rappdirs::user_cache_dir("rnoaa/ersst") to using tools::R_user_dir("rnoaa/ersst", which = "cache").

The previous release had missed a use of rappdirs::user_cache_dir in the tests.

Thanks!
Daniel Hocking
