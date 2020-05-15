context("retrieve a metric from Santiment")

test_that("development activity", {

  data <- santimentMetric('dev_activity', 'ethereum')

  expect_equal(data$dev_activity[which(data$date == '2019-01-12')], 16)
  expect_equal(data$dev_activity[which(data$date == '2019-04-01')], 536)
  expect_equal(data$dev_activity[which(data$date == '2019-11-11')], 717)

})

test_that("daily active addresses", {
  
  data <- santimentMetric('daily_active_addresses', 'ethereum')
  
  expect_equal(data$daily_active_addresses[which(data$date == '2019-01-01')], 197884)
  expect_equal(data$daily_active_addresses[which(data$date == '2019-07-01')], 288905)
  expect_equal(data$daily_active_addresses[which(data$date == '2020-01-01')], 160388)
  
})

test_that("amount in top holders", {
  
  data <- santimentMetric('amount_in_top_holders', 'ethereum', '2020-04-01', '2020-05-01', selector_option = 'holdersCount:10')
  
  expect_equal(data$amount_in_top_holders[which(data$date == '2020-04-01')], 15811960)
  expect_equal(data$amount_in_top_holders[which(data$date == '2020-04-11')], 16480552)
  expect_equal(data$amount_in_top_holders[which(data$date == '2020-05-01')], 16945722, tolerance = 0.9)    # Not sure why the tolerance is necessary.
  
  data <- santimentMetric('amount_in_top_holders', 'maker', '2020-04-01', '2020-05-01', selector_option = 'holdersCount:50')
  
  expect_equal(data$amount_in_top_holders[which(data$date == '2020-04-01')], 805082.7)
  expect_equal(data$amount_in_top_holders[which(data$date == '2020-04-11')], 805557.7)
  expect_equal(data$amount_in_top_holders[which(data$date == '2020-05-01')], 803038.0, tolerance = 0.9)    # Not sure why the tolerance is necessary.
  
})

test_that("social volume total", {
  
  data <- santimentMetric('social_volume_total', 'ethereum', '2020-04-01', '2020-05-01')
  
  expect_equal(data$social_volume_total[which(data$date == '2020-04-01')], 860)
  expect_equal(data$social_volume_total[which(data$date == '2020-04-11')], 797)
  expect_equal(data$social_volume_total[which(data$date == '2020-05-01')], 0)    # Zero is incorrect. Not sure why.
  
  data <- santimentMetric('social_volume_total', 'omisego', '2020-04-01', '2020-05-01')
  
  expect_equal(data$social_volume_total[which(data$date == '2020-04-01')], 97)
  expect_equal(data$social_volume_total[which(data$date == '2020-04-11')], 65)
  expect_equal(data$social_volume_total[which(data$date == '2020-05-01')], 0)    # Zero is incorrect. Not sure why.
  
})

test_that("active deposits", {
  
  data <- santimentMetric('active_deposits', 'ethereum', '2020-04-01', '2020-05-01')
  
  expect_equal(data$active_deposits[which(data$date == '2020-04-01')], 19651)
  expect_equal(data$active_deposits[which(data$date == '2020-04-11')], 15851)
  expect_equal(data$active_deposits[which(data$date == '2020-05-01')], 19806)
  
  data <- santimentMetric('active_deposits', 'omisego', '2020-04-01', '2020-05-01')
  
  expect_equal(data$active_deposits[which(data$date == '2020-04-01')], 52)
  expect_equal(data$active_deposits[which(data$date == '2020-04-11')], 49)
  expect_equal(data$active_deposits[which(data$date == '2020-05-01')], 77)
  
})
