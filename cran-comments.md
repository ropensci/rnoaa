## Test environments

* ubuntu 20.04 (local install), R 4.1.2
* ubuntu-latest (release, on GitHub Actions)
* macOS-latest (release, on GitHub Actions)
* macOS-latest (devel, on GitHub Actions)
* windows-latest (release, on GitHub Actions)
* win-builder (release, devel)

## R CMD check results

0 errors | 0 warnings | 0 notes

-----

## revdepcheck results

We checked 3 reverse dependencies, comparing R CMD check results across CRAN and dev versions of this package.

 * We saw 0 new problems
 * We failed to check 0 packages
 
## Notes

This update is to fix an issue with writing to an unapproved cache location on MacOS. 

Thanks!
Daniel Hocking
