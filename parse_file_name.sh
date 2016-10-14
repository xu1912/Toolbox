#If you want a bash-only solution, you can start with:

a=/tmp/xx/file.tar.gz
xpath=${a%/*} 
xbase=${a##*/}
xfext=${xbase##*.}
xpref=${xbase%.*}
echo;echo path=${xpath};echo pref=${xpref};echo ext=${xfext}

## Result:
## path=/tmp/xx
## pref=file.tar
## ext=gz

##That little snippet sets xpath (the file path), xpref (the file prefix) and xfext (the file extension).
