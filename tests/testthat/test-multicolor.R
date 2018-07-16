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
      multi_color(colors = crayon::black)
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
      multi_color(colors = c(
        "seafoamgreen",
        "green"
      )) # bad colors
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
      multi_color(
        "you're gonna want me for your girl",
        c(
          sample(colors(), 3),
          rgb(0.1, 0.3, 0.5),
          rgb(0.6, 0.4, 0.2),
          "gray3", "#666666"
        )
      )
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
      colors = c("rainbow", "purple", "purple", "rainbow"),
      type = "string"
    ),
    "\033[38;5;196mas\033[39m\033[38;5;214md\033[38;5;226mf\033[38;5;46mj\033[38;5;21mk\033[38;5;129ml\033[38;5;129m;\033[38;5;129ma\033[38;5;196ms\033[38;5;214md\033[38;5;226mf\033[38;5;46mj\033[38;5;21mk\033[38;5;129m;\n"
  )
})

test_that("integration with cowsay", {
  expect_silent(
    suppressMessages(cowsay::say(
      what = "I'm a rare Irish buffalo",
      by = "buffalo",
      what_color = "pink",
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


testthat("Windows is skipped", {
  skip_on_os("windows")

  expect_silent(
    suppressWarnings(multi_color(
      txt = cowsay::animals[["yoda"]],
      type = "warning",
      colors = c("rainbow", "rainbow")
    ))
  )

  expect_silent(
    suppressWarnings(multi_color(
      txt = "small text",
      type = "warning"
    ))
  )
})


test_that("utils", {

  # Rainbow
  expect_equal(
    insert_rainbow(c("lightsteelblue", "rainbow", "lightsalmon")),
    c(
      "lightsteelblue", "red", "orange", "yellow",
      "green", "blue", "purple", "lightsalmon"
    )
  )

  expect_equal(
    crayon::blue,
    insert_rainbow(crayon::blue)
  )

  # Tags
  expect_equal(
    get_open_close("steelblue2"),
    list(open = "\033[38;5;117m", close = "\033[39m")
  )

  expect_equal(
    get_open_close(rgb(0.2, 0.4, 0.6)),
    list(open = "\033[38;5;67m", close = "\033[39m")
  )

  expect_equal(
    get_open_close("white"),
    list(open = "\033[37m", close = "\033[39m")
  )
})
