library(crayon)

context("multicolor")

test_that("baseline works", {
  expect_error(
    suppressMessages(
      multi_color(TRUE)
    )
  )

  expect_error(
    suppressMessages(
      multi_color(123)
    )
  )

  expect_error(
    suppressMessages(
      multi_color(type = "foo")
    )
  )

  expect_error(
    suppressMessages(
      multi_color(colors = "blue") # need more than 1 color
    )
  )

#   expect_equal(
#     suppressMessages(
#       msg <- testthat::capture_error(multi_color(colors = c("seafoamgreen",
#                              "green"))) # bad colors
#     ),
#   'Error in multi_color(colors = c("seafoamgreen", "green")): All colors must be R color strings or hex values.
# The input(s) seafoamgreen cannot be used.'
#   )

  expect_error(
    suppressMessages(
      multi_color(colors = c("seafoamgreen",
                            "green")) # bad colors
    )
  )

  expect_silent(
    suppressMessages(
      multi_color("one fine day")
    )
  )
})

test_that("colors(), including grays, rainbow, and rbg work", {

  expect_silent(
    suppressMessages(
      multi_color("you're gonna want me for your girl",
                  c(sample(colors(), 3),
                    rgb(0.1, 0.3, 0.5),
                    rgb(0.6, 0.4, 0.2),
                    "gray3", "#666666"))
    )
  )

  expect_silent(
    suppressMessages(
      multi_color("asdfjkl;asdfjk;", colors = "rainbow")
    )
  )

  # Multiple of the same colors
  expect_equal(
      multi_color("asdfjkl;asdfjk;",
                  colors =c("rainbow", "purple", "purple", "rainbow"),
                  type = "string"),
      "\033[31mas\033[39m\033[33md\033[33mf\033[32mj\033[34mk\033[35ml\033[35m;\033[35ma\033[31ms\033[33md\033[33mf\033[32mj\033[34mk\033[35m;\n"
  )

})

test_that("integration with cowsay", {
  expect_silent(
    suppressMessages(cowsay::say( # what = "I'm a rare Irish buffalo",
      txt = "buffalo", what_color = "pink",
      by_color = c("green", "white", "orange")
    ))
  )

  expect_silent(
    suppressMessages(
      cowsay::say("I'm not crying, you're crying",
        what_color = "green", # green,
        by_color = colors()
      )
    )
  )
})
