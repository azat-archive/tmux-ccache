#!/usr/bin/env bash

function run_script() { "$(dirname "${BASH_SOURCE[0]}")/scripts/$*"; }

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

    readarray stats < <(ccache_stats)

    local line

    # make assoc array
    declare -A stats_assoc
    for line in "${stats[@]}"; do
        local kv=( $line )
        local key="${kv[0]}"
        local val="${kv[1]}"
        stats_assoc["$key"]="$val"
    done

    # status(ccache_status) shortcut
    stats_assoc[status]="$ccache_icon ${stats_assoc[cache_hit_rate]}"

    # subst
    local key
    for key in "${!stats_assoc[@]}"; do
        local val="${stats_assoc[$key]}"
        local key="\#{ccache_${key}}"
        opt="${opt/$key/$val}"
    done

    echo "$opt"
}

function ccache_stats() { ccache --print-stats | run_script ccache.awk; }

function main()
{
    ccache_icon="$(tmux_get_option "@ccache_icon" "Ͼ")"

    tmux_update_option status-left
    tmux_update_option status-right
}
main "$@"
