#!/bin/bash
set -e
LIBS=/pylibs
for lib in cython matplotlib numpy scipy
do
    for version in $(cat $LIBS/$lib)
    do
        pip2 wheel -w $LIBS $lib==$version
        pip3 wheel -w $LIBS $lib==$version
    done
done
