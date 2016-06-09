#!/bin/bash
#branch=$(git rev-parse --abbrev-ref HEAD)
branch="Universal"
echo "$branch"   # your processing here
mkdir -p "ParrotMod/$branch"
mv ParrotMod_*_${branch}_2*.zip $branch/ 2>/dev/null
#show Windows files, if any
find . -not -type d -exec file "{}" ";" | grep CRLF

date=$(date +%Y-%m-%d_%H.%M.%S)

for Device in `find devices/ -maxdepth 1 -mindepth 1 -type d -printf "%f\n"`
do
#    if [ -d "${Device}" ]; then
		rm -rf "$(dirname "$0")/zip-temp"
		mkdir "$(dirname "$0")/zip-temp"
		cd "$(dirname "$0")/zip-temp"
		find . -name '.DS_Store' -delete
        echo "${Device}"   # your processing here
        #purge existing ZIP folder
        rm -rf *
        #populate ZIP folder with baseline
        cp -R ../zip/* .
        #overwrite ZIP folder with Device files
        cp -R ../devices/${Device}/* .
        zip -9 -r -q ../ParrotMod_${Device}_${branch}_${date}.zip *
        du -h ../ParrotMod_${Device}_${branch}_${date}.zip
        cd ..
        mv ParrotMod_${Device}_${branch}_2*.zip ParrotMod/$branch/ 2>/dev/null
        cd ParrotMod/$branch
        cn=1
        for i in `echo ParrotMod_${Device}_${branch}_2*.zip | tr ' ' '\n' | sort -r`; do
        	[ "$cn" -gt 4 ] && rm "$i"
        	cn=$(($cn+1))
        done
		cd ../..
#    fi
done
