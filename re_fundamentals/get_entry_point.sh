#!/bin/bash

file_name="$1"
[[ -z "$file_name" || ! -f "$file_name" ]] && file "$file_name" | grep -q ELF

readelf -h "$file_name" 2>/dev/null | awk -v fname="$file_name" '
/Magic:/ {for(i=2;i<=NF;i++) magic=(magic $i " ")}
/Class:/ {class=$2}
/Data:/ {byte_order=$2}
/Entry point address:/ {entry=$4}
END {
  print "ELF Header Information for \"" fname "\":"
  print "----------------------------------------"
  print "Magic Number:", magic
  print "Class:", class
  print "Byte Order:", byte_order
  print "Entry Point Address:", entry
}'
