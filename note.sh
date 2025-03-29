#!/bin/bash
# todo: multi line text
FILE="/tmp/note"
HABEO="$HOME/.note"
TIME=$(date +"%I:%M:%S")
NOTECOUNT=$(ls "$HABEO" 2>/dev/null | wc -l)
localEditor="ed"
BACKUP="~/Documents"

#NAMECHANGE=false
# requires:
# fzf
# ed
# stopwords

# Command-line options
while getopts ":dhsfeFoEA" option; do
    case $option in

	d)
            echo "File deleted"
            rm -f "$FILE"
            exit 0
            ;;

	h)
            echo "Usage: note [OPTION]"
            echo "Options:"
            echo "  -d      Delete the note file"
	    echo "  -s      Save file to $HABEO. (automatic naming)"
	    echo "  -f      Name file and save."
	    echo "  -D      Date file at start"
	    echo "  -h      Show help message"
            echo "  -e      Edit the note file"	    
	    echo "  -E      Edit from note directory"            
	    echo "  -o      Print from note directory"
	    echo "  -A      Archive $HABEO"
	    exit 0
            ;;

	s)
	    FILENAME=$(tr '[:upper:]' '[:lower:]' < /tmp/note | tr -s '[:space:]' '\n' | tr -d '[:punct:]' | grep -vwFf ~/.note/.stopwords.txt | grep -E '.{5,}' | sort | uniq -c | sort -nrk1,1 | awk '{print $2}' | head -n1)
	   
	   mv "$FILE" "$HABEO/$FILENAME"
            
	   echo "Saved to $HABEO/$FILENAME"
           exit 0
	    
	   ;;
	D)
            DATE=true
	    echo "Formatting toggled: $FORMAT"
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

	o)
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
	    #cp archive.tar.gz "$BACKUP/archive.tar.gz"
	    cp archive.tar.gz ~/Documents/archive.tar.gz
	  
	    echo "Archived to archive.tar.gz"
	    echo "Saved to $BACKUP"
	    exit 0
	    ;;
	\?)
            echo "Invalid option: -$OPTARG" >&2
            echo "Run 'note -h' for help"
            exit 1
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

# Append to the file with or without date
if [ "$DATE" = true ]; then
    echo "$(date +"%I:%M")" >> "$FILE"
    cat >> "$FILE"
else
    cat >> "$FILE"
fi
