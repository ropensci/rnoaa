library("devtools")

res <- revdep_check(threads = 4)
revdep_check_save_summary()
revdep_check_print_problems()
#revdep_email(date = "April 18", only_problems = FALSE, draft = TRUE)

# pkgs <- list(
#   list(your_package = "downscale", your_version = "1.2-4", email = "charliem2003@gmail.com"),
#   list(your_package = "plotKML", your_version = "0.5-6", email = "tom.hengl@isric.org"),
#   list(your_package = "speciesgeocodeR", your_version = "1.0-4", email = "alexander.zizka@bioenv.gu.se"),
#   list(your_package = "rCAT", your_version = "0.1.5", email = "J.Moat@kew.org")
# )
# date = "April 18"
#
# str <- paste0(readLines("revdep/email.md"), collapse = "\n")
# lapply(pkgs, function(x)
#   whisker::whisker.render(str, data = x)
# )
