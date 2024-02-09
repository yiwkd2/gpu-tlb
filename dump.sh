#!/bin/bash

if [ $# != 1 ]; then
    echo "Usage: ./dump.sh [file_name]"
    exit 1
fi

./dumper/dumper -d 0 -s 0 -b 0xf0000000 -o ./dump_dir/${1}
