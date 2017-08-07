#!/bin/sh
fir p bin/*.ipa -T $FIR_TOKEN -c "build from `git rev-list HEAD -1`"
