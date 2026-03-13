#!/bin/bash

read -p "IP : " IP
PORT=7890

old_proxies=(
    "$http_proxy"
    "$https_proxy"
    "$all_proxy"
)

export http_proxy="http://$IP:$PORT"
export https_proxy="http://$IP:$PORT"
export all_proxy="socks5://$IP:$PORT"

test_proxy() {
    curl -s --head --connect-timeout 5 "$1" >/dev/null && return 0 || return 1
}

sites=(
    "https://www.google.com"
    "https://www.youtube.com"
)

for site in "${sites[@]}"; do
    if ! test_proxy "$site"; then
        echo "Fail: $site，roll back..."
        export http_proxy="${old_proxies[0]}"
        export https_proxy="${old_proxies[1]}"
        export all_proxy="${old_proxies[2]}"
        exit 1
    fi
    echo "OK: $site"
done

echo "success"    
