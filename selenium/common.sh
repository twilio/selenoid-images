#!/bin/bash
set -e

get_browser_version() {
    local browser=$1
    local package_version=$2
    case ${browser} in
        chrome)
            echo "$(echo $package_version | awk -F '-' '{print $1}')"
            ;;
        firefox)
            echo "$(echo $package_version | awk -F '+' '{print $1}' | awk -F '~hg' '{print $1}' | sed -e 's/~//g')"
            ;;
        *)
            echo "$package_version"
            ;;
    esac
}

