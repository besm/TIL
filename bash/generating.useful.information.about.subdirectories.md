# Generating Useful Information about Subdirectories
## 2021-05-03

For the last couple of weekends, I've been working on a major reorganization of my file system. Since I've been doing this in a piecemeal fashion and want to be able to budget my time, I thought it would nice to get a quick birds-eye view of the directory I'm migrating. Namely, I want to have recursive counts of the number of files in a folder's subdirectories, the size of those files, and how deeply nested the directory is. Moreover, I wanted the the output to be formatted in such a way that I could do useful things with it: navigate to the most populated folder, navigate to the smallest directory, or whatever.

I thought I could knock this out in one simple script: one where I wrote a function to generate the desired data, then use find's -exec option to run the function on the subdirectories. But I found out something that I didn't know: find's -exec option [doesn't work with user-defined functions](https://unix.stackexchange.com/a/50695). I decided that instead of using xargs, that I'd split up the task into two different scripts `enumerator` and `census`. They both live in `$HOME\.local\bin`

Here's `enumerator`. I decided to exclude .git directories from my depth calculations.
```bash
#!/bin/bash

count="$(find "$1" -type f | wc -l)"
size="$(du -sh "$1" | awk '{ print $1 }')"
depth="$(find "$1" -type d -not -path '*/\.git/*' |\
     awk -F"/" 'NF > max {max = NF} END {print max - 1}')"

printf "%s\t%s\t%s\t%s\n"  "$count" "$size" "$depth" "$1"
```


And here's `census`. It has pretty colors and optionally takes folders as arguments. Since since directories sometimes have spaces in their names, I opted for tab separation. This works nicely with awk (e.g. `census | head -1 | awk -F"\t" '{ print $4}'`).

```bash
#!/bin/bash

formatter () {
    sort -nr |\
    sed "s/\.\///g" |\
    awk -F"\t" '{printf "%s\t\033[1;32m%s\t\033[00m\033[1;33m%s\t\033[00m\033[1;34m%s\033[00m\n", $1, $2, $3, $4;}'
}


if [ -z "$1" ]; then
    find . -mindepth 1 -maxdepth 1 \( ! -regex '.*/\..*' \) -type d -not -path '*/\.git/*' \
        -exec enumerator {} \; | formatter
else
    target="$(realpath "$1")"
    [ ! -d "$target" ] && exit
    find "$target" -mindepth 1 -maxdepth 1 \( ! -regex '.*/\..*' \) -type d -not -path '*/\.git/*' \
        -exec enumerator {} \; |\
        sed "s|$target\/||g" | formatter
fi

```

Here's what the output looks like: 

![census output](/img/census.png)
