#!/bin/bash

# Véri si un argument est fourni
if [ $# -ne 1 ]; then
    echo "Usage: $0 <ELF file>"
    exit 1
fi

file_name="$1"

# Véri si le fichier existe
if [ ! -f "$file_name" ]; then
    echo "Error: File '$file_name' not found!"
    exit 1
fi

# Véri si le fichier est un ELF
if ! file "$file_name" | grep -q "ELF"; then
    echo "Error: '$file_name' is not an ELF file!"
    exit 1
fi

# Extraction des informations avec readelf
magic_number=$(hexdump -n 4 -e '4/1 "%02x "' "$file_name")
class=$(readelf -h "$file_name" | grep "Class:" | awk '{print $2, $3}')
byte_order=$(readelf -h "$file_name" | grep "Data:" | awk '{print $2, $3}')
entry_point_address=$(readelf -h "$file_name" | grep "Entry point address:" | awk '{print $4}')

# Inclure messages.sh pour formater l'affichage
source messages.sh

# Appel de fonction pour afficher les résultats
display_elf_header_info

