#!/usr/bin/env python
import json, sys, os, re

def removeAnchor(line):
   if '<a' in line:
      pos = line.index('<a')
      if "</a>" in line:
         pos2 = line.index('</a>')
         return line[:pos] + ' ' + line[pos2+4:]
      else:
         return line[:pos]
   else: return line

def main():
   """"""
   with open(sys.argv[1]) as f:
      nb = json.load(f)
   
   # build table of contents
   
   toc = ['']
   chapter = 0
   for cell in nb['cells']:
      if cell["cell_type"] != "markdown": continue
      
      for i in range(len(cell['source'])):
         line = cell['source'][i]
         if (line.startswith('# ') or line.startswith('## ')) and not line.startswith("# Table of Contents"):
            prefix = line.index(' ')+1
            chapter += 1
            label = 'chapter' + str(chapter)
            title = removeAnchor(line)
            title = title.replace('\n', '')
            cell['source'][i] = title + (' <a id="%s"></a>\n' % label)
            stars = ' ' * (prefix - 2) + '*'
            toc += [ '%s [%s](#%s)\n' % (stars, title[prefix:], label) ]
   
   for cell in nb['cells']:
      if cell["cell_type"] != "markdown": continue
      res = []
      for i in range(len(cell['source'])):
         line = cell['source'][i]
         if line.startswith("# Table of Contents"):
            res.append(line+'\n')
            res.extend(toc)
            break
         else:
            res.append(line)
      cell['source'] = res        
      
   
   with open(sys.argv[2], 'w') as out:
      json.dump(nb, out, indent=2)

if __name__ == '__main__':
   main()
   