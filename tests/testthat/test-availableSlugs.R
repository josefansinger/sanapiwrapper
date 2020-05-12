context("get the available slugs for a metric")

test_that("get the available slugs for a metric", {

  data <- availableSlugs('daily_active_addresses')

  expect_equal(('ethereum' %in% data), TRUE)
  expect_equal(('0x' %in% data), TRUE)
  expect_equal(('bitcoin' %in% data), TRUE)

})

test_that("get the available slugs for a metric", {

  data <- availableSlugs('amount_in_top_holders')

  expect_equal(('ethereum' %in% data), TRUE)
  expect_equal(('0x' %in% data), TRUE)
  expect_equal(('bitcoin' %in% data), FALSE)

})
