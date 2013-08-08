# CONTRIBUTING #

### Please contribute! 
We love collaboration. 

### If you do contribute... 
Please follow these guidelines so that we can create good R packages that are easy to use and maintain. Forking and sending pull requests back to the master branch of this repo are best. 

### Guidelines for contribution
+ Documentation: All rOpenSci packages should use roxygen2 to document their functions. roxygen2 is an R package that automatically compiles your .Rd files in your man folder in your package if you write the documentation following certain rules. Check out Hadley's [devtools wiki][roxygen2]. It has some great advice for using roxygen2 to document R functions.

+ Vignettes: Contributing to vignettes is easy! We are moving towards writing all our vignettes in R Markdown, which is easy to write. These vignettes will be parsed to html on our web site. If you want to contribute to a vignette, make changes to the current .Rmd file in /inst/doc. If you want to add a new vignette, add a new file with a .Rmd extension in /inst/doc

+ Interacting with web based data: If you aren't familiar with working with web data in R, do get familiar with packages to make calls to web APIs, [RCurl][rcurl] and [httr][httr], and to parse data once its in R, mainly [RJSONIO][rjsonio], [rjson][rjson], and [XML][xml].

+ Do remember to track the upstream branch after you have forked this repo so that you can pull in any changes before you submit a pull request. 

+ Contributing requires forking our repos to your Github account, making your changes, then submitting a pull request. Let us know if you aren't sure how to do this.

+ Does this package build after your changes? Test this by doing `check(packagename)` within R using devtools, or `R CMD build path/to/package` then `R CMD CHECK packagename` after. If the package does not build correctly, don't submit a pull request. 

+ If you write a new function, try to write a test file for the function in the /inst/tests folder. Use functions from the `test_that` package to write tests, and see [this wiki][wikitest] for help.

### If you have any questions, get in touch: [info@ropensci.org](mailto:info@ropensci.org)

### Thanks for contibuting!

### If you have suggested changes for these contribution guidelines do let us know.

[roxygen2]: https://github.com/hadley/devtools/wiki/Documenting-functions
[rcurl]: http://cran.r-project.org/web/packages/RCurl/index.html
[httr]: http://cran.r-project.org/web/packages/httr/index.html
[rjson]: http://cran.r-project.org/web/packages/rjson/index.html
[rjsonio]: http://cran.r-project.org/web/packages/RJSONIO/index.html
[xml]: http://cran.r-project.org/web/packages/XML/index.html
[wikitest]: https://github.com/hadley/devtools/wiki/Testing