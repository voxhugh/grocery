#!/usr/bin/env python3
"""
proxy_test.py - Test proxy connectivity in WSL2 mirrored mode
Usage: python3 proxy_test.py
"""

import os
import urllib.request
import urllib.error
import socket

TARGETS = [
    ("Google",  "https://www.google.com"),
    ("YouTube", "https://www.youtube.com"),
    ("GitHub",  "https://github.com"),
    ("Twitter", "https://twitter.com"),
    ("StackOverflow", "https://stackoverflow.com"),
]

TIMEOUT = 5

def test_url(name, url):
    try:
        req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
        with urllib.request.urlopen(req, timeout=TIMEOUT) as resp:
            code = resp.getcode()
            if 200 <= code < 400:
                return True, code, "OK"
            return False, code, f"HTTP {code}"
    except urllib.error.HTTPError as e:
        if 300 <= e.code < 400:
            return True, e.code, "Redirect"
        return False, e.code, f"HTTP {e.code}"
    except urllib.error.URLError as e:
        if isinstance(e.reason, socket.timeout):
            return False, 0, "TIMEOUT"
        if "Name or service not known" in str(e.reason):
            return False, 0, "DNS FAIL"
        return False, 0, f"URL Error: {e.reason}"
    except Exception as e:
        return False, 0, f"Error: {e}"

def main():
    print("=== Proxy Test (WSL mirrored mode) ===")
    print(f"http_proxy:  {os.environ.get('http_proxy', 'NOT SET')}")
    print(f"https_proxy: {os.environ.get('https_proxy', 'NOT SET')}")
    print("-" * 40)

    success_count = 0
    for name, url in TARGETS:
        ok, code, msg = test_url(name, url)
        status = "[PASS]" if ok else "[FAIL]"
        print(f"{status} {name:15} {code:>3}  {msg}")
        if ok:
            success_count += 1

    print("-" * 40)
    print(f"Result: {success_count}/{len(TARGETS)} reachable")

    if success_count == 0:
        print("Check: V2RayN/Clash running? Allow LAN on? Firewall ok?")

if __name__ == "__main__":
    main()
