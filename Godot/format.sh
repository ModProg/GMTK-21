#! /bin/env bash
if test -f ~/.local/bin/gdformat; then
  ~/.local/bin/gdformat $(find . -name '*.gd')
else 
   gdformat $(find . -name '*.gd')
fi
