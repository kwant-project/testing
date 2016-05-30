#!/bin/bash
set -e
LIBS=/pylibs
REQS=""
for lib in cython matplotlib numpy scipy
do
    REQS="$REQS $lib==$(tail -1 $LIBS/$lib)"
done
echo $REQS
