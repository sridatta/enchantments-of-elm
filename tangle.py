#!/usr/bin/env python

import sys

print
in_code = False
for line in sys.stdin:
  if line.startswith('```haskell'):
    in_code = True
    continue

  if in_code and line.startswith('```'):
    in_code = False
    print "\n"
    continue

  if in_code:
    print line
