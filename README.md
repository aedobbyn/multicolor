[![Travis build
status](https://travis-ci.org/aedobbyn/multicolor.svg?branch=master)](https://travis-ci.org/aedobbyn/multicolor)

# multicolor 🎨

Color your strings, messages, and errors.

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
#> Hello world
```

If you want the bare string back with color encodings, use `type =
"string"`.

``` r
multi_color("Some words here",
  type = "string")
#> Some words here
```

The default is to message the result.

``` r
multi_color("Some words here",
            sample(colors(), 
                   sample(10, 1)))
#> Some words here
```

Pairs nicely with the [`cowsay`](https://github.com/sckott/cowsay)
package:

``` r
library(cowsay)

say(what = "holygrail", 
    by = "yoda",
    what_color = "olivedrab",
    by_color = c("tomato1", "saddlebrown", "springgreen4", "turquoise2"))
#>  ----- 
#> Found them? In Mercia?! The coconut's tropical! 
#>  ------ 
#>     \   
#>      \
#>                    ____
#>                 _.' :  `._
#>             .-.'`.  ;   .'`.-.
#>    __      / : ___\ ;  /___ ; \      __
#>   ,'_ ""--.:__;".-.";: :".-.":__;.--"" _`,
#>   :' `.t""--.. '<@.`;_  ',@>` ..--""j.' `;
#>        `:-.._J '-.-'L__ `-- ' L_..-;'
#>           "-.__ ;  .-"  "-.  : __.-"
#>              L ' /.------.\ ' J
#>              "-.   "--"   .-"
#>              __.l"-:_JL_;-";.__
#>          .-j/'.;  ;""""  / .'\"-.
#>          .' /:`. "-.:     .-" .';  `.
#>       .-"  / ;  "-. "-..-" .-"  :    "-.
#>   .+"-.  : :      "-.__.-"      ;-._   \
#>   ; \  `.; ;                    : : "+. ;
#>   :  ;   ; ;                    : ;  : \:
#>   ;  :   ; :                    ;:   ;  :
#>   : \  ;  :  ;                  : ;  /  ::
#>   ;  ; :   ; :                  ;   :   ;:
#>   :  :  ;  :  ;                : :  ;  : ;
#>   ;\    :   ; :                ; ;     ; ;
#>   : `."-;   :  ;              :  ;    /  ;
#>  ;    -:   ; :              ;  : .-"   :
#>   :\     \  :  ;            : \.-"      :
#>   ;`.    \  ; :            ;.'_..--  / ;
#>   :  "-.  "-:  ;          :/."      .'  :
#>    \         \ :          ;/  __        :
#>     \       .-`.\        /t-""  ":-+.   :
#>      `.  .-"    `l    __/ /`. :  ; ; \  ;
#>        \   .-" .-"-.-"  .' .'j \  /   ;/
#>         \ / .-"   /.     .'.' ;_:'    ;
#>   :-""-.`./-.'     /    `.___.'
#>                \ `t  ._  /  bug
#>                 "-.t-._:'
#> 
```

Error in style:

``` r
my_msg <- 
  say(what = "Error: something went horribly wrong",
    by = "rms",
    what_color = "orange",
    by_color = c("red", "red", "orange", "red", "red", "orange", "red", "red"),
    type = "warning")
#> Warning in say(what = "Error: something went horribly wrong", by = "rms", :  ----- 
#>  
#> Error: something went horribly wrong 
#>  ------ 
#>     \   
#>      \
#>                     @@@@@@ @
#>                   @@@@     @@
#>                  @@@@ =   =  @@ 
#>                 @@@ @ _   _   @@ 
#>                  @@@ @(0)|(0)  @@ 
#>                 @@@@   ~ | ~   @@
#>                 @@@ @  (o1o)    @@
#>                @@@    #######    @
#>                @@@   ##{+++}##   @@
#>               @@@@@ ## ##### ## @@@@
#>               @@@@@#############@@@@
#>              @@@@@@@###########@@@@@@
#>             @@@@@@@#############@@@@@
#>             @@@@@@@### ## ### ###@@@@
#>              @ @  @              @  @
#>                @                    @

e <- simpleError(my_msg)
tryCatch(log("foo"), error = function(e) message(my_msg))
#>  ----- 
#>  
#> Error: something went horribly wrong 
#>  ------ 
#>     \   
#>      \
#>                     @@@@@@ @
#>                   @@@@     @@
#>                  @@@@ =   =  @@ 
#>                 @@@ @ _   _   @@ 
#>                  @@@ @(0)|(0)  @@ 
#>                 @@@@   ~ | ~   @@
#>                 @@@ @  (o1o)    @@
#>                @@@    #######    @
#>                @@@   ##{+++}##   @@
#>               @@@@@ ## ##### ## @@@@
#>               @@@@@#############@@@@
#>              @@@@@@@###########@@@@@@
#>             @@@@@@@#############@@@@@
#>             @@@@@@@### ## ### ###@@@@
#>              @ @  @              @  @
#>                @                    @
```
