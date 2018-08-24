
[![Travis build
status](https://travis-ci.org/aedobbyn/multicolor.svg?branch=master)](https://travis-ci.org/aedobbyn/multicolor)
[![Coverage
status](https://codecov.io/gh/aedobbyn/multicolor/branch/master/graph/badge.svg)](https://codecov.io/github/aedobbyn/multicolor?branch=master)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/aedobbyn/multicolor?branch=master&svg=true)](https://ci.appveyor.com/project/aedobbyn/multicolor)

# multicolor 🎨 <img src="./man/img/egret.jpg" alt="egret" height="225px" align="right">

Apply multiple colors to your messages and warnings. Built on the
[`crayon`](https://github.com/r-lib/crayon) package. Pairs nicely with
[`cowsay`](https://github.com/sckott/cowsay). [Bit of backstory and
walkthrough of how it
works](https://dobb.ae/2018/07/19/how-does-multicolor-actually-work/).

### Installation

``` r
# install.packages("devtools")
devtools::install_github("aedobbyn/multicolor")
```

Note: this package cannot be run from the R GUI. RStudio or any terminal
work fine.

## Usage

``` r
library(multicolor)
```

Supply a character vector of colors to `colors`. Defaults to
`"rainbow"`, i.e., `c("red", "orange", "yellow", "green", "blue",
"purple")`. The text supplied will be divided into even(ish) vertical
chunks of those colors.

``` r
multi_color("Hello world")
```

<p align="left">

<img src="./man/img/hello_world.jpg" alt="hello_world" height="25px">

</p>

Or a more fun example, contributed by @hcortinajust:

<p align="left">

<img src="./man/img/plasma_daemon.png" alt="hello_world" height="600px">

</p>

**Options**

If you want the bare string back with color encodings attached, use
`type = "string"`.

Ask [important questions](https://youtu.be/B759dzymyoc?t=14s):

``` r
multi_color("Why are avocado pits so big?",
  type = "string")
```

<p align="center">

<img src="./man/img/avocado_q_2.jpg" alt="avocado_q" height="20px">

</p>

The default is to message the
result.

``` r
multi_color("The wild avocado grows in subtropical jungles, so the new sprout has to get several feet tall before it can share sunlight (to make food) with its neighbors. Until it grows out of their shadows, it relies on nutrients in the seed, so it'd better be big.",
            sample(colors(), 
                   sample(10, 1)))
```

<p align="center">

<img src="./man/img/avocado_a.jpg" alt="avocado_a" height="70px">

</p>

### ASCII art with [`cowsay`](https://github.com/sckott/cowsay)

All `cowsay` animals are exported in `multicolor::things`, but to get
the animals to speak, you need `cowsay`.

``` r
library(cowsay)

say(what = "holygrail", 
    by = "yoda",
    what_color = "olivedrab",
    by_color = c("tomato1", "saddlebrown", "springgreen4", "turquoise2"))
```

<p align="left">

<img src="./man/img/yoda.jpg" alt="yoda" height="300px">

</p>

The default is to color vertically, but horizontal is also an option. If
you want to make a Dutch shark, you can set the `direction` param to
“horizontal”.

``` r
multi_color(things[["shark"]], 
            colors = c("darkred", "white", "darkblue"),
            direction = "horizontal")
```

<p align="left">

<img src="./man/img/dutch_shark.jpg" alt="dutch_shark" height="400px">

</p>

Error in style:

``` r
my_error <- multi_color("An unknown error has occurred.", 
                        type = "string")

stop(my_error)
```

<p align="left">

<img src="./man/img/err.jpg" alt="error" height="17px">

</p>

And with character:

``` r
my_msg <- 
  say(what = "Error: something went horribly wrong",
    by = "rms",
    what_color = "orange",
    by_color = c("red", "red", "orange", "red", "red", "orange", "red", "red"),
    type = "string")

e <- simpleError(my_msg)
tryCatch(log("foo"), error = function(e) message(my_msg))
```

<p align="left">

<img src="./man/img/rms_error.jpg" alt="rms" height="400px">

</p>

``` r
this_variable <- "foo"
this_option <- "bar"

say(what = 
      glue::glue("Aha, I see you set {this_variable} to {this_option}. Excellent choice."),
    by = "owl",
    what_color = c("salmon2", "springgreen4"),
    by_color = c("turquoise3", "peachpuff3", "seagreen3"))
```

<p align="left">

<img src="./man/img/foo_to_bar.jpg" alt="foo_to_bar" height="250px">

</p>
