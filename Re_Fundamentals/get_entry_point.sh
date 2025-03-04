#!/bin/bash

# Vérifier si un argument est fourni
if [ $# -ne 1 ]; then
    echo "Usage: $0 <ELF file>"
    exit 1
fi

file_name="$1"

# Vérifier si le fichier existe
if [ ! -f "$file_name" ]; then
    echo "Error: File '$file_name' not found!"
    exit 1
fi

# Vérifier si le fichier est un ELF
if ! file "$file_name" | grep -q "ELF"; then
    echo "Error: '$file_name' is not an ELF file!"
    exit 1
fi

# Extraire les informations avec readelf en supprimant les espaces
magic_number=$(hexdump -n 16 -e '16/1 "%02x "' "$file_name" | sed 's/ $//')
class=$(readelf -h "$file_name" | grep "Class:" | awk '{print $2}' | tr -d ' ')
byte_order=$(readelf -h "$file_name" | grep "Data:" | awk '{print $(NF-1), $NF}' | sed 's/,//g' | tr -s ' ')
entry_point_address=$(readelf -h "$file_name" | grep "Entry point address:" | awk '{print $4}')

# Inclure messages.sh pour formater l'affichage
source messages.sh

# Appeler la fonction pour afficher les résultats
display_elf_header_info

