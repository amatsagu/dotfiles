#!/bin/bash

mkdir ~/.local/share/icons -p
curl -sL https://github.com/phisch/phinger-cursors/releases/latest/download/phinger-cursors-variants.tar.bz2 | tar xfj - -C ~/.local/share/icons
mkdir ~/.icons/default -p
cp ./cursor-index.theme ~/.icons/default/index.theme