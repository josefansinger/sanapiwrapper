context("retrieve a metric from Santiment")

test_that("get development activity for ethereum", {

  data <- santimentMetric('dev_activity', 'ethereum')

  expect_equal(data$dev_activity[which(data$date == '2019-01-12')], 16)
  expect_equal(data$dev_activity[which(data$date == '2019-04-01')], 536)
  expect_equal(data$dev_activity[which(data$date == '2019-11-11')], 717)

})

test_that("get daily active addresses for ethereum", {

  data <- santimentMetric('daily_active_addresses', 'ethereum')

  expect_equal(data$daily_active_addresses[which(data$date == '2019-01-01')], 197884)
  expect_equal(data$daily_active_addresses[which(data$date == '2019-07-01')], 288905)
  expect_equal(data$daily_active_addresses[which(data$date == '2020-01-01')], 160388)

})
