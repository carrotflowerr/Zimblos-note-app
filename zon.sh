#!/bin/bash

# BTW: now using ed as default behavior

# todo: 

# requires:
# fzf
# ed
# stopwords file

auto_name() {
    fname=$(tr '[:upper:]' '[:lower:]' < "$FILE" |
        tr -s '[:space:]' '\n' |
        tr -d '[:punct:]' |
        grep -vwFf "$STOPWORDS" 2>/dev/null |
        grep -E '.{5,}' |
        sort | uniq -c | sort -nrk1 | awk '{print $2}' | head -n1)
    [ -z "$fname" ] && fname="note_$(date +"$TIME_FORMAT")"
    echo "$fname"
}


FILE="/tmp/note"
HABEO="$HOME/.note"
TIME=$(date +"%I:%M:%S")
NOTECOUNT=$(ls "$HABEO" 2>/dev/null | wc -l)
localEditor="ed"
BACKUP="~/Documents"
#NAMECHANGE=false

# Command-line options
while getopts ":dhsfeFPEAiX" option; do
    case $option in

	d)
            echo "Text Cleared"
            rm -f "$FILE"
            exit 0
            ;;

	h)
            echo "Usage: note [OPTION]"
            echo "Options:"
            echo "  -d      Delete the note file"
	    echo "  -s      Save file to $HABEO. (automatic naming)"
	    echo "  -f      Name file and save."
	    echo "  -h      Show help message"
            echo "  -e      Edit the note file"	    
	    echo "  -E      Edit from note directory"            
	    echo "  -P      Print from note directory"
	    echo "  -i      Run ispell on the buffer"
	    echo "  -X      Encrypt"
	    echo "  -w      Open stopwords"
	    echo "  -A      Archive $HABEO"
	    exit 0
            ;;

	s)

	    FILENAME=$(auto_name)

	   echo "Saving to: $HABEO/$FILENAME"
	    
	   mv -i "$FILE" "$HABEO/$FILENAME"
            



           exit 0
	    
	   ;;

	e)
	    ed "$FILE"
	    # TODO: make use localEditor
	    exit 0
            ;;

	f)

	    if [ -n "$2" ]; then  # Check if $2 is not empty
		FILENAME="$2"
	    else
		echo "Error: No filename provided."
		exit 1  
	    fi
            mv "$FILE" "$HABEO/$FILENAME"
            echo "Saved to $HABEO/$FILENAME"
            exit 0
	    ;;

	P)
	    # this should sort by date
	    cd "$HABEO"
	    file=$(fzf)
	    echo "$file"
	    cat "$file"
	    
	    exit 0
	    ;;

	E)
	    cd "$HABEO"
	    ed $(fzf)
	    exit 0
	    ;;

	A)
	    cd "$HABEO"
	    tar -czf archive.tar.gz *


	    echo "Archived to archive.tar.gz"
	    echo "Saved to $BACKUP, /mnt/Second/, /mnt/Third/"
	    exit 0
	    ;;

	i)
	    ispell "$FILE"
	    exit 0
	    ;;

	w)
	    ${EDITOR:-ed} "$STOPWORDS"
	    ;;

	X)
	    chosenFile=$(fzf)
	    GPG_TTY=$(tty)
	    export GPG_TTY
	    gpg --pinentry-mode loopback --symmetric "$chosenFile"
	    # requires config
	    rm -i "$chosenFile"
	    ;;

    esac
done

# make sure file exists
if [ -f "$FILE" ]; then
    sed -n 'p' "$FILE"
else
    echo "File created."
    #echo "$(date)" >> "$FILE"
fi

ed "$FILE"
# cat >> "$FILE"
