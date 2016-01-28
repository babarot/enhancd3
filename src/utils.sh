#!/bin/bash

# __die puts a string to stderr
__die() {
    printf "$@" >&2
}

# __unique uniques a stdin contents
__unique() {
    if __empty "$1"; then
        cat <&0
    else
        cat "$1"
    fi | awk '!a[$0]++' 2>/dev/null
}

# __reverse reverses a stdin contents
__reverse() {
    if __empty "$1"; then
        cat <&0
    else
        cat "$1"
    fi \
        | awk -f "$ENHANCD_ROOT/share/reverse.awk" \
        2>/dev/null
}

# __available narrows list down to one
__available() {
    local x candidates

    # candidates should be list like "a:b:c" concatenated by a colon
    candidates="$1:"

    while [ -n "$candidates" ]; do
        # the first remaining entry
        x=${candidates%%:*}
        # reset candidates
        candidates=${candidates#*:}

        # check if x is __available
        if __has "${x%% *}"; then
            echo "$x"
            return 0
        else
            continue
        fi
    done

    return 1
}

# __empty returns true if $1 is __empty value
__empty() {
    [ -z "$1" ]
}

# __has returns true if $1 exists in the PATH environment variable
__has() {
    if __empty "$1"; then
        return 1
    fi

    type "$1" >/dev/null 2>&1
    return $?
}

# __nl reads lines from the named file or the standard input if the file argument is ommitted,
# applies a configurable line numbering filter operation and writes the result to the standard output
__nl() {
    # d in awk's argument is a delimiter
    awk -v d="${1:-": "}" '
    BEGIN {
        i = 1
    }
    {
        print i d $0
        i++
    }' 2>/dev/null
}
