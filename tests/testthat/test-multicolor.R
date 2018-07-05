library(crayon)

context("multicolor")

test_that("baseline works", {

  expect_error(
    suppressMessages(
      multi_color()))

  expect_error(
    suppressMessages(
      multi_color(123)))

  expect_error(
    suppressMessages(
      multi_color(type = "foo")))

  expect_silent(
    suppressMessages(
      multi_color("one fine day")))

  expect_error(
    suppressMessages(multi_color("warnings aren't allowed",
                                 type = "warning"))
  )

})

test_that("integration with cowsay", {
  expect_silent(
    suppressMessages(cowsay::say(# what = "I'm a rare Irish buffalo",
                         txt = "buffalo", what_color = "pink",
                         by_color = c("green", "white", "orange")))
  )

  expect_silent(
    suppressMessages(
      cowsay::say("I'm not crying, you're crying",
          what_color = "green", # green,
          by_color = colors())
    )
  )

})
