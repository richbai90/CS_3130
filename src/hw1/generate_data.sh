#!/bin/bash
[ -d ".python" ] && echo "A pyenv named .python already exists. This could be from a previous version of this process that failed to clean up.  Please remove this folder before continuing." \
&& exit

echo "Refreshing virtual environment"

python3 -m venv .python

source ./.python/bin/activate

echo "Installing required modules"

pip3 install -r python/requirements.txt

echo "Generating data files"

python3 ./python/main.py

rm -rf .python

