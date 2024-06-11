#!/usr/bin/env bash

if [ $# -ne 1 ]; then
  echo """
  USAGE: $0 [PROJECT_DIR]

    PROJECT_DIR    the directory where the project will be created
  """ >&2
  exit 2
fi
d=$1

if [ -d $d ]; then
  echo "ERROR: directory '$d' already exists" >&2
  exit 1
fi
mkdir -p $d
pushd $d

cat << EOF > lists.txt
LIST OF QUARKS
==============
up
down
weird
charm
top
bottom

LIST OF JEFFERSON LAB HALLS
===========================
A
C
D

LIST OF NUCLEONS
================
electron
proton
neutron
EOF

mkdir -p info
echo 'u d s c t b' > info/quarks.txt
echo 'a b c d' > info/halls.txt

mkdir -p data
echo '1 6 2 5 7 3 0' > data/1000.dat
echo '5 6 1 8 9 6 5' > data/2000.dat
echo '9 5 8 6 4 3 2' > data/3000.dat
echo '9 5 8 6 4 3 2' > sample_data.dat

popd
