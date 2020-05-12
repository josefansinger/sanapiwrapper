context("get the available metrics for a slug")

test_that("get the metrics for ethereum", {

  data <- availableMetrics('ethereum')

  expect_equal(('amount_in_top_holders' %in% data), TRUE)
  expect_equal(('dev_activity' %in% data), TRUE)
  expect_equal(('social_volume_total' %in% data), TRUE)

})

