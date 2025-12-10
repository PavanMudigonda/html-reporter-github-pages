#!/usr/bin/env python3

# DEPRECATED: This script is kept for backward compatibility only.
# Please use index-html-generator.py --order descending instead.
# This file will be removed in a future version.

import sys
import os

# Add the scripts directory to the path
script_dir = os.path.dirname(os.path.abspath(__file__))

# Simply call the main script with descending order
os.execv(sys.executable, [sys.executable, os.path.join(script_dir, 'index-html-generator.py'), '--order', 'descending'] + sys.argv[1:])
