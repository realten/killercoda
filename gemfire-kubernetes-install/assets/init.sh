#!/bin/bash

cat <<EOT > /root/.vimrc
set expandtab
set tabstop=2
set shiftwidth=2
EOT


# scenario specific
wget https://get.helm.sh/helm-v3.8.2-linux-amd64.tar.gz
tar xzf helm-v3.8.2-linux-amd64.tar.gz
mv linux-amd64/helm /usr/bin/
chmod a+x /usr/bin/helm
rm -rf linux-amd64 helm-v3.8.2-linux-amd64.tar.gz

# scenario finished
rm $0