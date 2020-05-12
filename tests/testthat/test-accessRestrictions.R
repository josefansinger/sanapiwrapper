context("get access restrictions")

test_that("no access restrictions", {

  data <- accessRestrictions('daily_active_addresses')

  expect_equal(data$isRestricted, FALSE)
  expect_equal(data$name, "daily_active_addresses")
  expect_equivalent(is.na(data$restrictedFrom), TRUE)
  expect_equivalent(is.na(data$restrictedTo), TRUE)
  expect_equal(data$type, "metric")

})

test_that("access restrictions", {

  data <- accessRestrictions('amount_in_top_holders')

  expect_equal(data$isRestricted, TRUE)
  expect_equal(data$name, "amount_in_top_holders")
  expect_equivalent(is.na(data$restrictedFrom), FALSE)
  expect_equivalent(is.na(data$restrictedTo), FALSE)
  expect_equal(data$type, "metric")

})
