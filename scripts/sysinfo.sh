#!/bin/bash

EVENTBREAK="#####"

cat /proc/cpuinfo | grep -E 'Model' | awk '{$2=$2};1'

echo $EVENTBREAK