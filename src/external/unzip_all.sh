#!/bin/bash

for f in *.zip; do  echo "Unzipping $f"; unzip "$f"; done
