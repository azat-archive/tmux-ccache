#!/usr/bin/env bash

function get_script() { echo "$(dirname "${BASH_SOURCE[0]}")/scripts/$*"; }

function tmux_get_option()
{
    local option="$1" && shift
    local default_value="$1" && shift
    local option_value="$(tmux show-option -gqv "$option")"
    [ -z "$option_value" ] && echo "$default_value" || echo "$option_value"
}
function tmux_set_option()
{
    local option="$1" && shift
    local value="$1" && shift
    tmux set-option -gq "$option" "$value"
}
function tmux_update_option()
{
    local option="$1" && shift
    local option_value="$(tmux_get_option "$option")"
    local new_option_value="$(substitude_option "$option_value")"
    tmux_set_option "$option" "$new_option_value"
}
function substitude_option()
{
    local opt="$1" && shift

    local key
    while read -r key; do
        local key_fmt="\#{ccache_${key}}"
        local val_cmd="#($(get_script ccache.sh) -vicon=$ccache_icon -vkey=$key)"
        opt="${opt/$key_fmt/$val_cmd}"
    done < <(ccache_stats)

    echo "$opt"
}

function ccache_stats() { $(get_script ccache.sh); }

function main()
{
    ccache_icon="$(tmux_get_option "@ccache_icon" "Ͼ")"

    tmux_update_option status-left
    tmux_update_option status-right
}
main "$@"
