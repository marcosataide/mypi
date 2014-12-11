#!/bin/sh
for src in *.avi; do
   mv "$src" "${src%.avi}.mp4"; 
done
