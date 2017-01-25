#!/usr/bin/env python
import json, sys, os, re
def main():
   """"""
   with open(sys.argv[1]) as f:
      nb = json.load(f)
   for cell in nb['cells']:
      if cell["cell_type"] != "code": continue
      res = []
      active = True
      for line in cell['source']:
         if '# BEGIN SOLUTION' in line:
            active = False
            res.append(line)
         elif '# END SOLUTION' in line:
            active = True
            res.append(line)
         elif active:
            res.append(line)
      cell['source'] = res
      cell['outputs'] = []
   with open(sys.argv[2], 'w') as out:
      json.dump(nb, out, indent=2)
      
if __name__ == '__main__':
   main()
