# Bash Extension

An attempt to limit bash to my specific use cases: text parsing and light automation.

:'
<name TBD>: a (text focused) DSL for Bash 5.1+
designed for script writing, but can be sourced interactively

full syntax TBD, but mostly just standard / simplified 
versions of regularly used commands

scripts written with this dsl should be able to exec
using only bash, without an compliation / interpret step
scripts using this dsl can mix bash and dsl in the same file
any command line tool (in $PATH) can be used directly in the file
'

:'
use alternative bash syntax for things:

- multiline comments use the :'comment' construction

- create simple function using the func keyword
  - these are loaded into the environment automatically

func "name" args...

- single line functions can be used without 
  the function keyword or brackets:

newfunc() echo "this is a different new func";

- bash has ternary statements

`((var=var2*arr[2]))`

- bash has string lists (nums work too)
  - these cant be iterated by default

echo {apples,oranges,pears,grapes}

- scripts using various "set" commands can use the init:: and exit:: functions


https://ss64.com/osx/eval.html
eval "grep" "-a" "$string"
https://ss64.com/osx/exec.html
exec "grep -a $string"

set +m
set -o pipefail # return code from item that fails in pipe
set -o nounset # do not allow unset variables
set -o privileged # use a restricted shell

(return 0 2>/dev/null) && sourced=1 || sourced=0

Other things that will help for more general programming:

Statistics

- [st](https://github.com/nferraz/st)
- brew install st

Unicode Character Info

- [chars](https://github.com/antifuchs/chars/)
- brew install chars

Generate Regular Expressions

- [grex](https://github.com/pemistahl/grex)
- brew install grex

Shell Helpers

- [shtool](https://www.gnu.org/software/shtool/)
- brew install shtool

Field Extraction

- [pk](https://github.com/johnmorrow/pk)
- brew install pk
  
HTTP Requests

- [burl](https://github.com/tj/burl)
- brew install burl
