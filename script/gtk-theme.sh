#!/bin/bash

mkdir ./fluent-gtk-theme -p
curl -sL https://github.com/vinceliuice/Fluent-gtk-theme/archive/refs/tags/2024-06-12.tar.gz | tar -xzf - -C ./fluent-gtk-theme
cd ./fluent-gtk-theme/Fluent-gtk-theme-2024-06-12
./install.sh -t yellow -c dark -s standard -i debian -l --tweaks noborder
cd -
rm ./fluent-gtk-theme -r