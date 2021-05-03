#!/bin/bash

tilroot="$HOME/www/til"
today="$(date '+%Y-%m-%d')"

lister () {
    find "$tilroot" -type d -not -path '*/\.*' | sed 1d | sed 's/^.*til\///g'
    printf "NEW"
}

typegen() {
    read -r til_type < <(lister | fzf --prompt="Type >>  ")
    if [[ "$til_type" = "NEW" ]]; then
        read -r -p "Name:   " til_type
        til_type="$(echo "$til_type" | tr " " "."| tr '[:upper:]' '[:lower:]')"
        mkdir "$tilroot/$til_type"
    fi
    til_dir="$tilroot/$til_type"
}

filegen() {
    read -r -p "Name:   " til_title
    til_filename="$(echo "$til_title" | tr " " "."| tr '[:upper:]' '[:lower:]')"
    { 
    echo "---"
    echo "title: \"$(titlecase "$til_title")\""
    echo "date: \"$today\""
    echo "---"
    printf "\n\n"
    } >> "$til_dir/$til_filename.md"
    cd "$til_dir" && git add "$til_filename.md" || exit
}

typegen
filegen
nvim "$til_dir/$til_filename.md"
git commit -m "Add $(titlecase "$til_title")"