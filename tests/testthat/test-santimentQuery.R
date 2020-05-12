context("execute a query")

test_that("get available queries", {

  result <- santimentQuery('{
    projectBySlug(slug: "ethereum") {
      availableQueries
    }
  }')

  data <- result$data$projectBySlug$availableQueries

  expect_equal(('getMetric' %in% data), TRUE)
  expect_equal(('gasUsed' %in% data), TRUE)
  expect_equal(('ethTopTransactions' %in% data), TRUE)

})

test_that("get available time series metrics", {

  result <- santimentQuery('{
    all_metrics_for_a_slug: projectBySlug(slug: "ethereum") {
      availableTimeseriesMetrics
    }
  }')

  data <- result$data$all_metrics_for_a_slug$availableTimeseriesMetrics

  expect_equal(('amount_in_top_holders' %in% data), TRUE)
  expect_equal(('price_usd' %in% data), TRUE)
  expect_equal(('velocity' %in% data), TRUE)

})

