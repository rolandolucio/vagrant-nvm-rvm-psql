 #!/usr/bin/env bash
echo "================================
Install NodeJS
================================"
 source $HOME/.nvm/nvm.sh

nvm install $1
nvm alias default $1

 shift

