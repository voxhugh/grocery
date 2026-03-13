#!/usr/bin/env python3
"""
Simple 256-color utilities for terminal.
"""

import sys

def c(text, color_code, bold=False, bg=False):
    """256 color text"""
    mode = '48' if bg else '38'
    style = ';1' if bold else ''
    return f"\033[{mode};5;{color_code}{style}m{text}\033[0m"

def rgb(text, r, g, b, bold=False, bg=False):
    """RGB true color text"""
    mode = '48' if bg else '38'
    style = ';1' if bold else ''
    return f"\033[{mode};2;{r};{g};{b}{style}m{text}\033[0m"

def show_colors():
    """Display all 256 colors (0-231)"""
    print("\n256 COLORS (0-231):\n")
    
    print("STANDARD (0-15):")
    for i in range(0, 16):
        block = f"\033[48;5;{i}m  \033[0m"
        text = f"\033[38;5;{i}m{i:3d}\033[0m"
        print(f"{block}{text}", end=' ')
        if (i + 1) % 8 == 0:
            print()
    print()
    
    print("216 COLORS (16-231):")
    for i in range(16, 232, 6):
        line = ''
        for j in range(6):
            color = i + j
            block = f"\033[48;5;{color}m   \033[0m"
            line += f"{block}{color:3d} "
        print(line)
        if (i - 16) % 36 == 30:
            print()

def preview():
    """Preview common colors"""
    print("\nCOMMON COLORS:")
    colors = [(1,"red"),(2,"green"),(3,"yellow"),(4,"blue"),
              (5,"purple"),(6,"cyan"),(9,"bright red"),(10,"bright green"),
              (14,"bright cyan"),(166,"orange"),(200,"pink"),(51,"sky blue")]
    for code, name in colors:
        print(f"{c(name, code)} ({code:3d})")

def show_usage():
    print("""
Usage: python colors.py [option]

Options:
  --colors    show full 256-color palette
  --preview   show common colors

Import functions:
  from ecolors import c, rgb
  c(text, code, bold=False, bg=False)       # 256-color text
  rgb(text, r, g, b, bold=False, bg=False)  # RGB text
""")

if __name__ == "__main__":
    if len(sys.argv) == 1:
        show_usage()
    elif sys.argv[1] == '--colors':
        show_colors()
    elif sys.argv[1] == '--preview':
        preview()
    else:
        print(f"Unknown: {sys.argv[1]}")
        show_usage()