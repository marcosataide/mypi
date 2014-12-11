#!/bin/sh
for src in *.mp4; do
   mv "$src" "${src%.mp4}.avi"; 
done
