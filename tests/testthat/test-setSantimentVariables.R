context("set Santiment environment variables")

test_that("set API key only", {

  setSantimentVariables("y4i3n5xk6p")

  expect_equal(Sys.getenv("SANTIMENT_API_KEY"), "y4i3n5xk6p")

})

test_that("set API key and URL", {

  setSantimentVariables("y4i3n5xk6p", "https://api.santiment.net/graphql")

  expect_equal(Sys.getenv("SANTIMENT_API_KEY"), "y4i3n5xk6p")
  expect_equal(Sys.getenv("SANTIMENT_API_URL"), "https://api.santiment.net/graphql")

})
