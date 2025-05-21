#!/bin/bash

# Simple text-menu interface for zon

FILE="/tmp/note"
HABEO="$HOME/.note"
BACKUP="$HOME/Documents"
STOPWORDS="$HABEO/.stopwords.txt"
TIME_FORMAT="%Y%m%d_%H%M%S"

# Ensure environment
mkdir -p "$HABEO"
touch "$FILE"

display_menu() {
    clear
    echo "Zimblo's Own Notes"
    echo "---------"
    echo "e) Edit buffer ($FILE)"
    echo "s) Save note (auto name)"
    echo "f) Save note (manual name)"
    echo "E) Edit note archive"
    echo "P) Print note archive"
    echo "i) Spell-check note"
    echo "d) Delete buffer"
    echo "X) Encrypt a file from archive"
    echo "w) Edit stopwords.txt"
    echo "A) Archive all notes"
    echo "q) Quit "
    #read -p "> " $NULL
    
}

pause() {
    read -p "Press Enter to continue..."
}

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

while true; do
    display_menu
    IFS= read -rsn1 choice
#    echo "$choice"
    case "$choice" in
        e)
            ed "$FILE"
            ;;

        s)
            name=$(auto_name)
            mv -i "$FILE" "$HABEO/$name"
            touch "$FILE"
            echo "Saved as $HABEO/$name"
            pause
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
	
	f)
            read -p "Enter filename: " name
            mv -i "$FILE" "$HABEO/$name"
            touch "$FILE"
            echo "Saved as $HABEO/$name"
            pause
            ;;

	E)
            cd "$HABEO"
            chosenFile=$(fzf)
            [ -n "$chosenFile" ] && ${EDITOR:-ed} "$chosenFile"
            pause
            ;;

	P)
            cd "$HABEO"
            file=$(fzf)
            [ -n "$file" ] && cat "$file"
            pause
            ;;

	i)
            ispell "$FILE"
            pause
            ;;

	d)
            rm -i "$FILE"
            touch "$FILE"
            echo "Current note reset."
            pause
            ;;

	A)
            tar -czf "$HABEO/archive_$(date +"$TIME_FORMAT").tar.gz" -C "$HABEO" .
            cp "$HABEO"/*.tar.gz "$BACKUP" 2>/dev/null
            echo "Archive created in $HABEO and copied to $BACKUP."
            pause
            ;;

	q)
            break
            ;;
        *)
            echo "Invalid choice."
            pause
            ;;
    esac
done

exit 0
