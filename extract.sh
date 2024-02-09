#!/bin/bash

if [ $# != 1 ]; then
    echo "Usage: ./extract.sh [dump_file_name]"
    exit 1
fi

./extractor/extractor ./dump_dir/${1} > ./extract_dir/${1}.txt
