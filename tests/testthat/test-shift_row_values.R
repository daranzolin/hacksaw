df <- data.frame(
  w = c(NA, 1, NA, NA),
  x = c(NA, NA, 1, NA),
  y = c(NA, NA, 2, 5),
  z = c(5, 1, 9, 2),
  z2 = c(1, 5, 6, 7),
  z3 = c(NA, NA, 8, NA),
  z4 = 1:4
)

test_that("Can shift data frame row values left", {
  out <- shift_row_values(df)
  expect_equal(sum(sapply(out[,c(1:3)], function(x) sum(is.na(x)))), 0)
})

test_that("Can shift data frame row values right", {
  out <- shift_row_values(df, .dir = "right")
  expect_equal(sum(sapply(out[,c(5:7)], function(x) sum(is.na(x)))), 0)
})

test_that("Can shift tibble row values", {
  dftbl <- tibble::tibble(df)
  out <- shift_row_values(dftbl)
  expect_true(inherits(out, "tbl"))
})

test_that("Can shift values with 'at'", {
  out <- shift_row_values(df, at = 1:2)
  expect_equal(sum(sapply(out[c(1:2),c(1:3)], function(x) sum(is.na(x)))), 0)
})


