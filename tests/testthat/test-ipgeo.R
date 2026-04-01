test_that("ipgeo errors when api_key is missing", {
  expect_error(
    ipgeo("8.8.8.8", api_key = ""),
    "api_key"
  )
})

test_that("ipgeo errors when ip is not character", {
  expect_error(
    ipgeo(123, api_key = "test"),
    "character"
  )
})

test_that("include does not allow dot notation", {
  expect_error(
    ipgeo("8.8.8.8",
          api_key = "test",
          include = "security.level"),
    "dot notation"
  )
})
