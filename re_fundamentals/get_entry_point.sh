#!/bin/bash
source ./messages.sh

# validate one ELF file argument
if [ $# -ne 1 ] || [ ! -f "$1" ] || ! file "$1" | grep -q ELF; then
  echo "Usage: $0 <elf_file> (must be an ELF file)"
  exit 1
fi

# extract fields with one awk pipeline
IFS=$'\n' read -r magic_number class byte_order entry_point_address < <(
  readelf -h "$1" | awk -F: '
    /Magic:/ {gsub(/^[ \t]+/,"",$2); print $2}
    /Class:/ {gsub(/^[ \t]+/,"",$2); print $2}
    /Data:/ {gsub(/^[ \t]+/,"",$2); print $2}
    /Entry point address:/ {gsub(/^[ \t]+/,"",$2); print $2}
  '
)

export file_name="$1"
export magic_number
export class
export byte_order
export entry_point_address

display_elf_header_info
