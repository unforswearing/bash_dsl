# Bash DSL

**This script targets bash 5.1+ on MacOS**

Bash DSL is a set of commands to provide abstraction for the parts of bash I never remember, specifically focused on non-interactive text processing and light scripting. Additionally, this script restricts bash and disables some builtin commands by default: `let` is used for setting variables, the `function` keyword has been aliased to `namespace`, possibly others. All of this is very experimental and very specific to my setup so *caveat emptor* and godspeed. Use this at your own risk.

## An abridged list of options

An individual function for each relevant `set` option

```
init::verbose() { set -x; }
init::strict() { set -euo pipefail; }
init::posix() { set -o posix; }
init::pipefail() { set -o pipefail; }
init::onecmd() { set -o oneccmd; }
init::noclobber() { set -o noclobber; }
...
...
```

`init` commands have associated `exit` commands

```
exit::verbose() { set +x; }
exit::strict() { set +euo pipefail; }
exit::posix() { set +o posix; }
exit::pipefail() { set +o pipefail; }
exit::onecmd() { set +o oneccmd; }
exit::noclobber() { set +o noclobber; }
...
...
```

`assert` is a replacement for `if`

```
assert [empty_or_null
        bool
        true
        false
        function
        ...]
```

`assert` also handles numerical comparisons

```
assert <num> eq | ne | gt | ... <num>
```

There are individual functions for external tools, including `pandoc` (`tool.pandoc`), `media-info` (`tool.mediainfo`), and `ffmpeg` (`tool.ffmpeg`).

Readonly variables use the `const` keyword.

The `filter` command can match on pcre(?) or posix regex.

`func` provides an option to copy (memoize) functions.

A new `list` datastructure is available, based on (and using) python lists

Typical string methods are available `str split`, `str trim`, `str length`, etc.

Other string methods include `str to_int`, `str append`, `str to_char_list`.

