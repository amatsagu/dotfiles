#!/bin/bash

cat << EOF
# ===========================================================================
# GOLANG 1.22.2 INSTALLATION
# ===========================================================================
EOF

wget -O ~/GolangSetup.deb "https://dl.google.com/go/go1.22.2.linux-amd64.tar.gz"
sudo tar -C /usr/local/ -xzf ~/GolangSetup.deb
rm ~/GolangSetup.deb
echo "export PATH=\$PATH:/usr/local/go/bin" >> ~/.profile

printf "\n\n\n\n\n\n\n\n\n\n"

cat << EOF
# ===========================================================================
# FINISHED INSTALLATION
# ===========================================================================
EOF
