#!/usr/bin/env bash
# pass qr - Password Store Extension (https://www.passwordstore.org/)
# Copyright (C) 2018 Josh VanderLinden
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#


PASSWORD_STORE_DIR="${PASSWORD_STORE_DIR:-$HOME/.password-store}"
PASS_QR_ROFI=${PASS_QR_ROFI:-0}
PASS_QR_FZF=${PASS_QR_FZF:-0}


cmd_qr_usage() {
    cat <<-_EOF
Usage:
    $PROGRAM qr [options] [output]
        Provide an interactive solution to generate QR codes for existing
        passwords. It will show all pass-names in either fzf or rofi, waits for
        the user to select one, then displays a QR code for the password. If an
        output path is specified, the QR code will be saved as a PNG to the
        specified location.

        The user can select fzf or rofi by giving either --fzf or --rofi.
        By default, rofi will be selected and pass-qr will fallback to
        fzf.

    Options:
        -f, --fzf        Use fzf to select pass-name.
        -r, --rofi       Use rofi to select pass-name.
_EOF
    exit 0
}

cmd_qr_short_usage() {
    echo "Usage: $PROGRAM $COMMAND [--help,-h] [--fzf,-f]|[--rofi,-r]"
}

command_exists() {
    command -v "$1" >/dev/null 2>&1 || exit 1
}

cmd_qr() {
    # Parse arguments
    local opts fzf=${PASS_QR_FZF} rofi=${PASS_QR_ROFI} output=""
    opts="$($GETOPT -o fr: -l fzf,rofi: -n "$PROGRAM $COMMAND" -- "$@")"
    local err=$?
    eval set -- "$opts"

    while true; do case "$1" in
            -f|--fzf) fzf=1; shift ;;
            -r|--rofi) rofi=1; shift ;;
            --) shift; break ;;
    esac done

    if [ ! -z "${@}" ]; then
        output=$(realpath "${@}")
    fi

    [[ $err -ne 0 ]] && die "$(cmd_qr_short_usage)"

    # Figure out if we use fzf or rofi
    local prompt='Copy password into clipboard for 45 seconds'
    local fzf_cmd="fzf --print-query --prompt=\"$prompt\" | tail -n1"
    local rofi_cmd="rofi -dmenu -i -p \"$prompt\""

    if [[ $fzf = 1 && $rofi = 1 ]]; then
        die 'Either --fzf,-f or --rofi,-r must be given, not both'
    fi

    if [[ $rofi = 1 || $fzf = 0 ]]; then
        command_exists rofi || die "Could not find rofi in \$PATH"
        menu="$rofi_cmd"
    elif [[ $fzf = 1 || $rofi = 0 ]]; then
        command_exists fzf || die "Could not find fzf in \$PATH"
        menu="$fzf_cmd"
    else
        if command_exists rofi; then
            menu="$rofi_cmd"
        elif command_exists fzf; then
            menu="$fzf_cmd"
        else
            die "Could not find either fzf or rofi in \$PATH"
        fi
    fi

    cd "$PASSWORD_STORE_DIR" || exit 1

    # Select a passfile
    passfile=$(find -L "$PASSWORD_STORE_DIR" -path '*/.git' -prune -o -iname '*.gpg' -printf '%P\n' \
        | sed -e 's/.gpg$//' \
        | sort \
        | eval "$menu" )

    if [ -z "$passfile" ]; then
        die 'No passfile selected.'
    fi

    if ls "$PASSWORD_STORE_DIR/$passfile.gpg" >/dev/null 2>&1; then
        if [ ! -z "${output}" ]; then
            echo -n $(cmd_show "$passfile" | head -1) | qrencode --size 10 --output "${output}" || exit 1
            echo "QR code written to ${output}"
        else
            cmd_show "$passfile" --qrcode || exit 1
        fi
    fi
}

[[ "$1" == "help" || "$1" == "--help" || "$1" == "-h" ]] && cmd_qr_usage
cmd_qr "$@"
