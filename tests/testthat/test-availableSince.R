context("get earliest date for which the metric is available")

test_that("get the available slugs for a metric", {

  data <- availableSince('daily_active_addresses', 'ethereum')

  expect_equal(data, '2015-07-30')

})

test_that("get the available slugs for a metric", {

  data <- availableSince('amount_in_top_holders', '0x')

  expect_equal(data, '2017-08-11')

})

