#!/opt/local/bin/bash
# @TODO incorporate nushell stuff:
# - ansi strip, build-string, collect, date to-table, do, empty?,
#   get name, lines, random dice, save, seq date, size, str lpad / rpad
#   term size, (list) to csv / json / md,
# environment provides settings for the entire script file.
readonly DSL_HELPER_DIR="/Users/unforswearing/Documents"
DEBUG=${DEBUG:-}
CONTINUE=${CONTINUE:-}
environment() {
  local opt="${1}"
  case "${opt}" in
  "nosource")
    [[ "${BASH_SOURCE[0]}" != "${0}" ]] && {
      echo "this script cannot be sourced"
      return 1
    }
    ;;
  "info")
    readonly __dir__
    readonly __root__
    readonly __file__
    readonly __base__
    __dir__="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    __root__="$(cd "$(dirname "${__dir__}")" && pwd)"
    __file__="${__dir__}/$(basename "${BASH_SOURCE[0]}")"
    __base__="$(basename ${__file__} .bash)"
    echo -en "dir: $__dir__\nroot: $__root__\nfile: $__file__\nbase: $__base__"
    ;;
  "stdout") /dev/stdout ;;
  "stderr") /dev/stderr ;;
  esac
}
# init:: and exit:: -- settings for individual functions or sections of script,
#                      not entire file.
# initialized items need to be exited
init::verbose() { set -x; }
init::strict() { set -euo pipefail; }
init::posix() { set -o posix; }
init::pipefail() { set -o pipefail; }
init::onecmd() { set -o oneccmd; }
init::noclobber() { set -o noclobber; }
init::nounset() { set -o nounset; }
init::noglob() { set -o noglob; }
init::noexec() { set -n; }
init::jobcontrol() { set -m; }
init::errtrace() { set -o errtrace; }
init::errexit() { set -o errexit; }
init::allexport() { set -o allexport; }
#--
exit::verbose() { set +x; }
exit::strict() { set +euo pipefail; }
exit::posix() { set +o posix; }
exit::pipefail() { set +o pipefail; }
exit::onecmd() { set +o oneccmd; }
exit::noclobber() { set +o noclobber; }
exit::nounset() { set +o nounset; }
exit::noglob() { set +o noglob; }
exit::noexec() { set +n; }
exit::jobcontrol() { set +m; }
exit::errtrace() { set +o errtrace; }
exit::errexit() { set +o errexit; }
exit::allexport() { set +o allexport; }
#--
# Default parameters for the DSL environment:
init::nounset
exit::jobcontrol
#--
# from bash oo framework -
#    https://github.com/niieani/bash-oo-framework/blob/master/lib/util/tryCatch.sh
# eg: try { ecfdsl "fake stuff"; } catch { echo "ecfdsl is not a real command"; }
source "$DSL_HELPER_DIR/Scripts/bash_extension/bin/trycatch.sh"
# audio viz helpers
source "$DSL_HELPER_DIR/Scripts/bash_extension/bin/audio.bash"
# lnks and aliaser
source "$DSL_HELPER_DIR/__Github/lnks-cli/lnks"
source "$DSL_HELPER_DIR/__Github/aliaser/aliaser"
#--
# disable the let builtin to use for variables
# dont really use or care about the other stuff
enable -n let logout mapfile readarray suspend ulimit
#-- tools for simplifying scripting
# properly align output into columns
tool.align() { /usr/local/bin/align "$@"; }
# get information about ascii chars
tool.chars() { /Users/unforswearing/.cargo/bin/chars "$@"; }
# chronic: run a command silently unless error
tool.chronic() { /opt/local/bin/chronic "$@"; }
# markdown stuff
tool.cmark() { /opt/local/bin/cmark "$@"; }
# standardize file / folder names
tool.detox() { /opt/local/bin/detox "$@"; }
# use dhall-to-bash to ensure correctness
# dhall-to-bash <<< 'dhall data struct'
tool.dhallbash() { /Users/unforswearing/.cabal/bin/dhall-to-bash "$@"; }
# generic preprocessor
tool.gpp() { /opt/local/bin/gpp "$@"; }
# generate regex for strings
tool.grex() { /opt/local/bin/grex "$@"; }
# run a program if standard input is not empty
tool.ifne() { /opt/local/bin/ifne "$@"; }
# file conversion from and to a lot of things
tool.pandoc() { /opt/local/bin/pandoc "$@"; }
# split input into two pipes
tool.pee() { /opt/local/bin/pee "$@"; }
# a field extractor like awk with easier syntax
tool.pk() { /usr/local/bin/pk "$@"; }
# info for media
tool.mediainfo() { /opt/local/bin/media-info "$@"; }
# get the modification date of a file
tool.moddate() { /usr/local/bin/shtool mdate "$1"; }
# run commands in parallel
tool.parallel() { /opt/local/bin/parallel "$@"; }
# create a shadow of a specified dir
tool.shadowdir() { /usr/local/bin/shtool mkshadow "$1"; }
# simple statistics
tool.st() { /usr/local/bin/st "$@"; }
# timestamp input
tool.ts() { /opt/local/bin/ts "$@"; }
# edit directories in EDITOR
tool.vidir() { /opt/local/bin/vidir "$@"; }
#-- audio / video tools
tool.ffmpeg() { /usr/local/bin/ffmpeg "$@"; }
# the following three are part of the sox package
tool.play() { /usr/local/bin/play "$@"; }
tool.sox() { /usr/local/bin/sox "$@"; }
tool.soxi() { /usr/local/bin/soxi "$@"; }
#-- alias typeof to "type -t" for the type not the full message
typeof() { type -t "${1}"; }
#--
# use namespace to load vars and functions into an environment
# eg:
# namespace example {
#   let value 12;
#   func show_value print $value;
#   }
# }
alias namespace='function'
#--
# loaded items do not need to be exited
# load can be used as a synonym for source, with additional options
load() {
  local opt="${1}"
  case "${opt}" in
  # using a color will change all of the following
  # printed text to that color until reset is called
  "colors")
    blue=$(tput setaf 4)
    green=$(tput setaf 2)
    red=$(tput setaf 1)
    yellow=$(tput setaf 3)
    reset=$(tput sgr0)
    ;;
  "namespace") eval "${2}" ;;
  "regex")
    RE_ALPHA="[aA-zZ]"
    RE_STRING="([aA-zZ]|[0-9])+"
    RE_WORD="\w"
    RE_NUMBER="\d"
    RE_NUMERIC="^[0-9]+$"
    RE_ALNUM="([aA-zZ]|[0-9])"
    RE_NEWLINE="\n"
    RE_SPACE=" "
    RE_TAB="\t"
    RE_WHITESPACE="\s"
    POSIX_UPPER="[:upper:]"
    POSIX_LOWER="[:lower:]"
    POSIX_ALPHA="[:alpha:]"
    POSIX_DIGIT="[:digit:]"
    POSIX_ALNUM="[:alnum:]"
    POSIX_PUNCT="[:punct:]"
    POSIX_SPACE="[:space:]"
    POSIX_WORD="[:word:]"
    ;;
  "strict")
    init::strict # set -euo pipefail
    init::verbose
    init::noexec
    #--
    source "${2}"
    #--
    exit::strict
    exit::verbose
    exit::noexec
    ;;
  *) source "${2}" ;;
  esac
}
#--
# assert: test things, use in place of if!
# eg: assert bool true; and bool yes; or bool no
and() { (($? == 0)) && "$@"; }
bool() {
  local opt="${1}"
  case "${opt}" in
  "no") echo "no" ;;
  "toggle")
    arr=(true false)
    printf '%s ' "${arr[${i:=0}]}"
    ((i = i >= ${#arr[@]} - 1 ? 0 : ++i))
    ;;
  "yes") echo "yes" ;;
  esac
}
or() { (($? == 0)) || "$@"; }
assert() {
  init::pipefail
  load regex
  # assert 2 ne 5 => true
  local opt="${1}"
  case "${opt}" in
  "empty_or_null") [[ -z "${2}" || "${2}" == "null" ]] && return 0 || return 1 ;;
  "bool") [[ "${2}" == true || "${2}" == false ]] && return 0 || return 1 ;;
  "true") [[ "${2}" == true || "${2}" -eq 0 ]] && return 0 || return 1 ;;
  "false") [[ "${2}" == false || "${2}" -eq 0 ]] && return 0 || return 1 ;;
  "function")
    local is_function
    is_function="$(typeof "${2}")"
    [[ ${is_function} == "function" ]] && return 0 || return 1
    ;;
  "number") [[ "${2}" =~ $RE_NUMBER ]] && return 0 || return 1 ;;
  "string") [[ "${2}" =~ $RE_STRING ]] && return 0 || return 1 ;;
  "numeric") [[ "${2}" =~ $RE_NUMERIC ]] && return 0 || return 1 ;;
  "unset") [ -z "${2+x}" ] && return 0 || return 1 ;;
  "dir") [ -d "${2}" ] && return 0 || return 1 ;;
  "file") [ -e "${2}" ] && return 0 || return 1 ;;
  *)
    local left="${1}"
    local right="${3}"
    case "${2}" in
    "eq") echo "${left} == ${right}" | bc ;;
    "ne") echo "${left} != ${right}" | bc ;;
    "gt") echo "${left} > ${right}" | bc ;;
    "lt") echo "${left} < ${right}" | bc ;;
    "ge") echo "${left} >= ${right}" | bc ;;
    "le") echo "${left} <= ${right}" | bc ;;
    "mod") echo "scale = 0; (${left} % ${right}) == 0)" | bc ;;
    *) print "${2} is not a valid comparator" ;;
    esac
    ;;
  esac
  exit::pipefail
}
# alias for cp to make things more safe
copy() {
  local opt="${1}"
  case "${opt}" in
  "clip") pbcopy <"${2}" ;;
  *) cp -i "$@" ;;
  esac
}
# use const instead of readonly
const() {
  local opt="${1}"
  case "${opt}" in
  "?") declare -r "${2}" ;;
  *)
    init::allexport
    eval "declare" "-r" "${1}=${2}"
    exit::allexport
    ;;
  esac
}
# a simple data cache
datacache() {
  init::pipefail
  cache_file=/tmp/${1}.cache
  # dtime="${2}"
  # shift; shift;
  efunc="$@"
  if [ -f "$cache_file" ]; then
    cat "$cache_file"
  else
    eval "$efunc" | tee "$cache_file"
  fi
  exit::pipefail
}
# very simple time and date
# https://geek.co.il/2015/09/10/script-day-persistent-memoize-in-bash
datetime() {
  local opt="${1}"
  case "${opt}" in
  "day") gdate +%d ;;
  "month") gdate +%m ;;
  "year") gdate +%Y ;;
  "hour") gdate +%H ;;
  "minute") gdate +%M ;;
  "now") gdate --universal ;;
    # a la new gDate().getTime() in javascript
  "get_time") gdate -d "${2}" +"%s" ;;
  "add_days")
    local convtime
    convtime=$(st get_time "$(st now)")
    timestamp="$(st get_time ${2})"
    day=${3:-1}
    gdate -d "$(gdate -d "@${timestamp}" '+%F %T')+${day} day" +'%s'
    ;;
  "add_months")
    declare timestamp month
    local convtime
    local ts
    convtime=$(st get_time "$(st now)")
    ts=$(st get_time ${2})
    timestamp="${ts:$convtime}"
    month=${3:-1}
    gdate -d "$(gdate -d "@${timestamp}" '+%F %T')+${month} month" +'%s'
    ;;
  "add_weeks")
    declare timestamp week
    local convtime
    local ts
    convtime=$(st get_time "$(st now)")
    ts=$(st get_time ${2})
    timestamp="${ts:$convtime}"
    week=${3:-1}
    gdate -d "$(gdate -d "@${timestamp}" '+%F %T')+${week} week" +'%s'
    ;;
  esac
}
# debug some stuff
debug() {
  init::jobcontrol
  load colors
  local opt="${1}"
  shift
  case "${opt}" in
  "info") echo -e "${blue}$@${reset}" ;;
  "important") echo -e "${yellow}$@${reset}" ;;
  "quiet") exit::verbose ;;
  "verbose") init::verbose ;;
  "warn") echo -e "${red}$@${reset}" ;;
  "die")
    echo >&2 -e "${red}$@${reset}"
    exit 1
    ;;
  esac
  exit::jobcontrol
}
# decrement a variable
decr() {
  local opt="${1}"
  local uopt=$((--opt))
  echo "${uopt}"
}
# filter a stream of text (multiple lines) using basic regex
# filter should be used in a pipe!
filter() {
  exit::nounset
  load regex
  local opt="${1}"
  local excl=
  [[ "$opt" == "exclude" ]] && {
    excl="!"
    opt="${2}"
  }
  case "${opt}" in
  "alpha") awk ${excl}/"${RE_ALPHA}"/ ;;
  "string") awk ${excl}/"${RE_STRING}"/ ;;
  "word") awk ${excl}/"${RE_WORD}"/ ;;
  "number") awk ${excl}/"${RE_NUMBER}"/ ;;
  "numeric") awk ${excl}/"${RE_NUMERIC}"/ ;;
  "alnum") awk ${excl}/"${RE_ALNUM}"/ ;;
  "newline") awk ${excl}/"${RE_NEWLINE}"/ ;;
  "space") awk ${excl}/"${RE_SPACE}"/ ;;
  "tab") awk ${excl}/"${RE_TAB}"/ ;;
  "whitespace") awk ${excl}/"${RE_WHITESPACE}"/ ;;
  "pupper") awk ${excl}/"${POSIX_UPPER}"/ ;;
  "plower") awk ${excl}/"${POSIX_LOWER}"/ ;;
  "palpha") awk ${excl}/"${POSIX_ALPHA}"/ ;;
  "pdigit") awk ${excl}/"${POSIX_DIGIT}"/ ;;
  "palnum") awk ${excl}/"${POSIX_ALNUM}"/ ;;
  "punct") awk ${excl}/"${POSIX_PUNCT}"/ ;;
  "pspace") awk ${excl}/"${POSIX_SPACE}"/ ;;
  "pword") awk ${excl}/"${POSIX_WORD}"/ ;;
  *) awk ${excl}/"${opt}"/ ;;
  esac
  init::nounset
}
# declare a function type
func() {
  local opt="${1}"
  case "${opt}" in
  "?") declare -f "${2}" ;;
  "memoize")
    local function="${1:?Missing function}"
    declare -F "$function" &>/dev/null || {
      echo "No such function $1"
      return 1
    }
    ;;
  *)
    shift
    init::allexport
    eval "$opt() { $@ ; };"
    exit::allexport
    ;;
  esac
}
garbagecollector() {
  # echo "if '$1' is sourced or in your \$PATH, reloading will restore the command"
  # forget the location of "$1" in the current shell
  hash -d "$1"
  # remove "$1" from the list of defined aliases
  unalias "$1"
  # unset shell variable "$1"
  unset "$1" &&
    echo "garbage-collector: 'unset $1' finished successfully"
  # unset shell function "$1"
  unset -f "$1" &&
    echo "garbage-collector: 'unset -f $1' finished successfully"
  # attempt to print a description of "$1". no result means "$1" is not found
  command -v "$1" ||
    echo "garbage-collector: 'command -v $1' $1 not found"
  echo "garbage-collector: attempt to execute '$1' as a command" && "$1"
  # echo "$1" as a variable to see if it produces any result
  echo "value of '$1': ${!1}" ||
    echo "garbage-collector: 'echo $1' produced no result"
}
# increment a variable
incr() {
  local opt="${1}"
  local uopt=$((++opt))
  echo "${uopt}"
}
# get user input
input() {
  read -r var
  echo "$var"
}
# work with variable values
# use const for readonly vars
# only using the function keyword to trigger syntax highlighting in editor
function let {
  local opt="${1}"
  case "${opt}" in
  "?")
    eval "echo" "\$${2}"
    ;;
  "replace_if_null")
    local item
    item="${2}"
    shift
    shift
    echo "${item:=$("$@")}"
    ;;
    # replace_if_exists var stringvar
  "replace_if_exists")
    local item
    item="${2}"
    shift
    shift
    echo ${item:+$("$@")}
    ;;
  # set a variable
  # eg: var name value
  *)
    init::allexport
    eval "${1}=${2}"
    exit::allexport
    ;;
  esac
}
# lists
# based on reading about the bash type system:
#   -> https://www.celantur.com/blog/bash-type-system/
# decided against using bash arrays for this as
# i have discovered they're kind of obtuse and the syntax sucks
list() {
  exit::nounset
  load regex
  local opt="${1}"
  local arg="${2}"
  local lst="$3"
  case "${opt}" in
  "?") eval "echo \$$arg" ;;
  "index")
    # eg: list index idx $listvar
    run python "tmp = $lst; print(tmp[$arg])"
    ;;
  "length")
    # get list length
    lst=$arg
    run python "print(len($lst))"
    ;;
  "push")
    # put allows adding a single item to the list
    run python "tmp = $lst; tmp.append($arg); print(tmp)"
    ;;
  "rm_index")
    # remove item at index
    run python "tmp = $lst; tmp.pop($arg); print(tmp)"
    ;;
  "to_string")
    # output a space delimited list for looping
    run python "tmp = $lst; print(' '.join(tmp))"
    ;;
  *)
    # a list is just a function that returns its arguments as output
    # lists can be all strings (incl. func names) or numbers. no mixing types in lists
    local members="$@"
    local test_item="$1"
    local sepmembers
    [[ "${test_item}" =~ $POSIX_WORD ]] && {
      sepmembers="\"${members// /\", \"}\""
    } || {
      sepmembers="${members// /, }"
    }
    run python "tmp = [${sepmembers}]; print(tmp)"
    ;;
  esac
  init::nounset
}
# simple math, use bc
# math function displays help and error messages
math() {
  init::pipefail
  echo "$@" | bc
}
# integers / numbers
# the number and int functions do the same thing
number() {
  local opt="${1}"
  case "${opt}" in
  "?") declare -i "${2}" ;;
  "to_string") echo "${2}" ;;
  *)
    shift
    eval "declare" "-i" "${1}=${2}"
    ;;
  esac
}
int() { number "${1}" "${2}"; }
#--
# order is a sort based tool
order() {
  init::pipefail
  local opt="${1}"
  case "${opt}" in
  "one_col") tsort "$@" ;;
  "shuf")
    awk 'BEGIN {srand(); OFMT="%.17f"} {print rand(), $0}' "$@" |
      sort -k1,1n | cut -d ' ' -f2-
    ;;
  "uniq") uniq "$@" ;;
  *) sort "$@" ;;
  esac
}
# waiting / sleeping / pausing
pause() {
  local opt="${1}"
  case "${opt}" in
  # sleep until a specific time $seconds from now
  "until")
    local secs=$(($(date -d "$2" +%s) - $(date +%s)))
    ((secs > 0)) && sleep $secs
    ;;
  *) sleep "${1}" ;;
  esac
}
# print to stdout
print() { echo "$@"; }
# a function to ensure things are properly quoted
quote() {
  local opt="${1}"
  case "${opt}" in
  "remove")
    shift
    local q="$@"
    q=${q//\'/}
    q=${q//\"/}
    echo $q
    ;;
  "wrap")
    shift
    local q="$@"
    echo "\"$(quote remove ${q})\""
    ;;
  esac
}
# reminders
rmd() {
  run bash "/Users/unforswearing/Documents/__Github/rmd-cli/rmd.bash" "$@"
}
# very simple repeat loop
# eg:
#   say_repeating() { echo "repeating..."; }
#   rpt 3 repeating
rpt() {
  local opt tot default range
  tot="${1}"
  default=100
  ((opt = tot > 0 ? tot : default))
  range=$(seq 1 $opt)
  shift
  for i in ${range}; do eval "$@"; done
}
# a simple command runner for other languages
# see also: load {apples,lua,node,python}
run() {
  # go and rust are compiled, so they cannot be run (afaik)
  local opt="${1}"
  shift
  case "${opt}" in
  "apples") "/usr/bin/osascript" -e "$@" ;;
  "bash") "/opt/local/bin/bash" -e "$@" ;;
  "lua") "/usr/local/bin/lua" -e "$@" ;;
  "node") "/usr/local/bin/node" -e "$@" ;;
  "nu") "/Users/unforswearing/.cargo/bin/nu" "$@" ;;
  "python") "/opt/local/bin/python" -c "$@" ;;
  "xonsh") "/usr/local/bin/xonsh" -c "$@" ;;
  "zsh") "/usr/local/bin/zsh" -c "$@" ;;
  esac
}
# string
str() {
  init::noredirect
  init::pipefail
  exit::nounset
  load regex
  local opt="${1}"
  local str="${2}"
  local xopt="${3}"
  shift
  case "${opt}" in
  "split") awk -F"$str" '{print $0}' ;;
  "lower") echo "${str}" | tr "$POSIX_UPPER" "$POSIX_LOWER" ;;
  "upper") echo "${str}" | tr "$POSIX_LOWER" "$POSIX_UPPER" ;;
  "length")
    local item="${str}"
    echo ${#item}
    ;;
  "lstrip") printf '%s\n' "${str##$xopt}" ;;
  "rstrip") printf '%s\n' "${str%%$xopt}" ;;
  "substr") echo "${str:xopt:yopt}" ;;
    # convert string numbers to non-string via expr
    # "math()" does this automatically via "bc"
  "to_int") echo $((str + 0)) ;;
  "trim")
    : "${str#"${str%%[![:space:]]*}"}"
    : "${_%"${_##*[!$POSIX_SPACE]}"}"
    printf '%s\n' "$_"
    ;;
  "append")
    # str append string "text" "separator"
    echo "$str""$xopt"
    ;;
  "join_lines")
    local delim=${str:-, }
    while read -r; do
      echo -ne "${REPLY}${delim}"
    done | sed "s/$delim$//"
    ;;
  "to_word_list")
    # lists are python lists. use python to split the string
    run python "tmp = \"${str}\"; str = tmp.split(); print(str)"
    ;;
  "to_char_list")
    # lists are python lists. use python to split the string
    run python "tmp = \"${str}\"; print([char for char in tmp])"
    ;;
  esac
  exit::noredirect
  exit::pipefail
  init::nounset
}
# system for file stuff
sys() {
  init::noclobber
  init::pipefail
  exit::nounset
  local opt="${1}"
  local xopt="${2}"
  local yopt="${3}"
  case "${opt}" in
  "read") echo "$(<"$xopt")" ;;
  "rename") mv -i "${xopt}" "${yopt}" ;;
  "backup") cp -i "$xopt"{,.bak} ;;
  "restore") cp "$xopt"{.bak,} ;;
  "mkcd") mkdir -p "$xopt" && cd "$xopt" ;;
  "file_path") echo "$(pwd)"/"${xopt}" ;;
  "search")
    case "$1" in
    "everywhere") location="${HOME}" ;;
    *) location="${1}" ;;
    esac
    /usr/local/bin/fd "$3" "${location}"
    ;;
  "ls")
    case "$xopt" in
    "dirs") ls -d */ ;;
    "files") fd -t d | grep -E -v '^d' ;;
    *) ls ;;
    esac
    ;;
  "create")
    case "$xopt" in
    "file") touch "$yopt" ;;
    "dir") mkdir "$yopt" ;;
    esac
    ;;
  "delete")
    case "$xopt" in
    "file") if [ -e "$yopt" ]; then
      rm "$yopt"
      return $?
    fi ;;
    "dir") if [ -e "$yopt" ]; then
      rm -irf "$yopt"
      return $?
    fi ;;
    esac
    ;;
    # use "assert dir" or "assert file" to check those things.
    # command_exists returns the command, not just true/false
  "command_exists")
    hash "${xopt}" 2>/dev/null
    ;;
  "convert_file")
    pandoc -o "$xopt" "$yopt"
    ;;
  esac
  exit::noclobber
  exit::pipefail
  init::nounset
}
# get stuff from the internet
# www() function displays help and error messages
www() {
  # use httpie because its better than old standbys (curl/wget)
  local opt="${1}"
  local url="${2}"
  case "${opt}" in
  "encode")
    # urlencode <string>
    old_lc_collate="$LC_COLLATE"
    LC_COLLATE=C
    local length="${#1}"
    for ((i = 0; i < length; i++)); do
      {
        local c="${url:i:1}"
        case "$c" in
        [a-zA-Z0-9.~_-]) printf "%s" "$c" ;;
        *) printf '%%%02X' "'$c" ;;
        esac
      } &
    done
    LC_COLLATE=$old_lc_collate
    ;;
  "decode")
    # urldecode <string>
    local url_encoded="${url//+/ }"
    printf '%b' "${url_encoded//%/\\x}"
    ;;
  *) echo "usage: web url [encode|decode]" ;;
  esac
}
# emulate xman on linux
xman() {
  init::pipefail
  man -t "$1" | open -f -a "Preview"
  exit::pipefail
}
debug info "dsl loaded."
