df <- data.frame(x = c(1, 2, NA, NA), y = c("a", NA, "b", NA))

test_that("keep_na returns the correct result", {
  out <- keep_na(df, x)
  expect_true(all(is.na(out$x)))
})

test_that("keep_na selects all columns", {
  expect_equal(nrow(keep_na(df)), 1)
})
