#!/bin/bash

for i in $1/*.json
do
  echo $i
  grep @
done
