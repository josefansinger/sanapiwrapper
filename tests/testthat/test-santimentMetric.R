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

test_that("get amount in top-10 holders for ethereum", {
  
  data <- santimentMetric('amount_in_top_holders', 'ethereum', '2020-04-01', '2020-05-01', selector_option = 'holdersCount:10')
  
  expect_equal(data$amount_in_top_holders[which(data$date == '2020-04-01')], 15811960)
  expect_equal(data$amount_in_top_holders[which(data$date == '2020-04-11')], 16480552)

})
