
[![Travis build
status](https://travis-ci.org/aedobbyn/multicolor.svg?branch=master)](https://travis-ci.org/aedobbyn/multicolor)

# multicolor 🎨 <img src="./man/img/egret.jpg" alt="egret" height="225px" align="right">

Apply multiple colors to your messages and warnings. Built on the
[`crayon`](https://github.com/r-lib/crayon) package. Pairs nicely with
[`cowsay`](https://github.com/sckott/cowsay).

### Installation

``` r
# install.packages("devtools")
devtools::install_github("aedobbyn/multicolor")
```

## Usage

``` r
library(multicolor)
```

Supply a character vector of colors to `colors`. Defaults to rainbow,
i.e., `c("red", "orange", "yellow", "green", "blue", "purple")`. The
text supplied will be divided into even(ish) vertical chunks of those
colors.

``` r
multi_color("Hello world")
```

<p align="left">

<img src="./man/img/hello_world.jpg" alt="hello_world" height="25px">

</p>

If you want the bare string back with color encodings, use `type =
"string"`.

``` r
multi_color("Why are avocado pits so big?",
  type = "string")
```

<p align="center">

<img src="./man/img/avocado_q.jpg" alt="avocado_q" height="100px">

</p>

The default is to message the
result.

``` r
multi_color("The wild avocado grows in subtropical jungles, so the new sprout has to get several feet tall before it can share sunlight (to make food) with its neighbors. Until it grows out of their shadows, it relies on nutrients in the seed, so it'd better be big.",
            sample(colors(), 
                   sample(10, 1)))
```

<p align="center">

<img src="./man/img/avocado_a.jpg" alt="avocado_a" height="60px">

</p>

### ASCII art with [`cowsay`](https://github.com/sckott/cowsay)

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

Error in
style:

``` r
my_error <- multi_color("An unknown error has occurred.", type = "string")

stop(my_error)
```

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
