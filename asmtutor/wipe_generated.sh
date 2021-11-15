#!/bin/sh

rm `ls | grep -v '.*.asm' | grep -v 'Readme.md' | grep -v 'wipe_generated.sh'`