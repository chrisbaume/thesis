TEMP_FILE=`mktemp`
latexpand --keep-includes --empty-comments "$1" | gsed '/^\s*%/d' > $TEMP_FILE
mv $TEMP_FILE "$1"
