#!/usr/bin/env python

import sys

def count(keywords, string):
  count = 0
  for k in keywords:
    if k.lower() in string.lower():
      count += 1
  return count

if __name__ == '__main__':
  if len(sys.argv) != 3:
    sys.exit('Usage: %s keywords_file data_file' % sys.argv[0])

  #TODO: check if args are existing files

  keywords_file = sys.argv[1]
  data_file = sys.argv[2]

  keywords = []
  data = {}

  # read keywords_file to fill the `keywords` list
  with open(keywords_file, 'r') as f:
    for line in f:
      keywords.append(line.rstrip())

  # read the `data_file`
  with open(data_file, 'r') as f:
    for line in f:
      value = line.rstrip()
      data[value] = count(keywords, value)

  # display result
  for v in sorted(data, key=data.get, reverse=True):
    print "%s (%s keyword(s) found!)" % (v, data[v])

  