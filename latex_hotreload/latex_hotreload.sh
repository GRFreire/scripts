#!/bin/bash

entry="$1"
files_to_watch=$()

if [ -z "$entry" ]; then
	echo "Error: no entry provided. See --help for usage"
	exit 1
fi

if [ "$entry" == "--help" ]; then
	echo "Usage: latex_hotreload [OPTIONS] entry_tex_file"
	echo ""
	echo "	OPTIONS:"
	echo "		--help:	show this help"
	echo ""
	echo "	STDIN:"
	echo "		The stdin should contain the files that should be watched for recompilation"
	echo "			Defaults to ./*.tex"
	echo ""
	echo "	ARGUMENTS:"
	echo "		entry_tex_file:	the entry latex file for compilation"
	echo ""
	exit 0
fi

output="$(echo "$entry" | sed 's/\.tex$/.pdf/')"

if test ! -t 0; then
	while IFS= read -r line
	do
		files_to_watch+=("$line")
	done
	
	files=$(printf "%s" "${files_to_watch[*]}")
	files="$(echo $files | sed 's/ /\n/')"
else
	files="$(find . -type f | grep "\.tex")"
fi

echo $files | sed 's/ /\n/g' | entr -s "pdflatex -shell-escape $entry" &
entr_pid=$!

while [ ! -f "$output" ]
do
  sleep 0.5
done

zathura "$output"

kill -s 2 "$entr_pid"
