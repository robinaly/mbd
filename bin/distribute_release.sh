#!/bin/bash
assignment=$1
shift
for d in students/*; do 
  #rsync -avug teacher/assignments/$assignment/ $d/$assignment/
  cp -avr teacher/assignments/$assignment/* $d/$assignment/
done
