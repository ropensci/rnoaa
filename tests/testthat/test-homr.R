test_that("homr", {
  skip_on_cran()
  skip_on_ci()

  # vcr::use_cassette("homr", {
    # qid
    a <- homr(qid = 'COOP:046742')
    # headersonly
    # b <- homr(headersOnly=TRUE, qid='TRANS:')
    # qid with preceding colon
    d <- homr(qid = ':046742')
    # qidmod
    e <- homr(qidMod='starts', qid='COOP:0467')
    # state
    f <- homr(headersOnly=TRUE, state='DE')
    # state and county
    g <- homr(headersOnly=TRUE, state='NC', county='BUNCOMBE')
    # name
    h <- homr(name='CLAYTON')
  # })

  # class
  expect_is(a, "homr")
  expect_is(unclass(a), "list")
  expect_is(a$`20002078`, "list")
  expect_is(a$`20002078`$head, "data.frame")
  expect_is(a$`20002078`$platform, "character")
  expect_equal(a$`20002078`$platform, "COOP")

  # expect_is(b, "homr")
  expect_is(d, "homr")
  expect_is(e, "homr")
  expect_is(f, "homr")
  expect_is(g, "homr")
  expect_is(h, "homr")

  # dimensions
  expect_equal(length(a), 1)
  expect_equal(length(a$`20002078`), 11)

  # expect_gt(length(b), 10)

  expect_equal(NROW(d$`20002078`$head), 1)

  expect_gt(length(e), 1)

  expect_match(f$`20004167`$head$preferredName, "DE")
})
