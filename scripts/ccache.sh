#!/usr/bin/env bash

function get_script() { echo "$(dirname "${BASH_SOURCE[0]}")/$*"; }
ccache --print-stats | $(get_script ccache.awk) "$@"
