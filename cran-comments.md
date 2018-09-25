## Test environments
* local OS X install, R 3.5.1
* ubuntu 12.04 (on travis-ci), R 3.5.1
* win-builder (devel and release)

## R CMD check results

0 errors | 0 warnings | 1 note

* The note is related to the size of the package, which is likely due to the screenshot and gif files that are used in the README. I've removed some of these to keep the package smaller.

## Reverse dependencies

Checked all reverse dependencies with devtools::revdep_check().
