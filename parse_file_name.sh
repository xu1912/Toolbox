If you want a bash-only solution, you can start with:

pax> a=/tmp/xx/file.tar.gz
pax> xpath=${a%/*} 
pax> xbase=${a##*/}
pax> xfext=${xbase##*.}
pax> xpref=${xbase%.*}
pax> echo;echo path=${xpath};echo pref=${xpref};echo ext=${xfext}

path=/tmp/xx
pref=file.tar
ext=gz

That little snippet sets xpath (the file path), xpref (the file prefix) and xfext (the file extension).
