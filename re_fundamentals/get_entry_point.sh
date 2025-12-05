#!/bin/bash

source ./messages.sh

# one command line arg
if [ $# -ne 1 ]; then
	echo "Usage: $0 <elf_file>"       
	exit 1
fi

# arg is a file
if [ ! -f "$1" ]; then
	echo "error not a file"
	exit 1
fi

# is type: elf file
if ! file "$1" | grep -q "ELF"; then
	echo "not an elf file"
	exit 1
fi

elf_magic=$(readelf -h "$1" | grep "Magic:" | awk '{$1=""; print $0}')
elf_class=$(readelf -h "$1" | grep "Class:" | awk '{$1=""; print $0}')
elf_byte_order=$(readelf -h "$1" | grep "Data:" | awk '{$1=""; print $0}')
elf_entry_point=$(readelf -h "$1" | grep "Entry point address:" | awk '{$1=""; $2=""; $3=""; print $0}')

arg1=$(echo "${elf_magic:1}")
arg2=$(echo "${elf_class:1}")
arg3=$(echo "${elf_byte_order:17}")
arg4=$(echo "${elf_entry_point:3}")

export file_name="$1"
export magic_number="$arg1"
export class="$arg2"
export byte_order="$arg3"
export entry_point_address="$arg4"
display_elf_header_info

