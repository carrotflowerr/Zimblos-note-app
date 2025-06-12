#!/bin/bash

# Simple text interface for note script
# TODO:
## Restore old archive function
## Write help menu
## making default file markdown might be beneficial. 

FILE="/tmp/note"
HABEO="$HOME/.note"
BACKUP="$HOME/Documents"
STOPWORDS="$HABEO/.stopwords.txt"
TIME_FORMAT="%Y%m%d_%H%M%S"

# Ensure environment
mkdir -p "$HABEO"
touch "$FILE"

EDITOR_CMD="${EDITOR:-ed}"

file_check() {
    state=$(file -b "$FILE")
    if [ "$state" = "empty" ]; then
	echo  "[]"
    else
	echo "[X]"
    fi
}

display_menu() {
    clear
    echo "Zimblo's Own Notes"
    echo "$(file_check)"
    echo "---------------------"

    # Basic
    echo "e) Edit"
    echo "s) Save "
    echo "d) Delete"
    echo "---------------------"

    # Management
    echo "E) Edit archive"
    echo "P) Print archive"
    echo "---------------------"

    # Operations
    echo "i) Spell-check"
    echo "X) Encrypt "
    echo "---------------------"


    # Misc
    echo "w) Edit stopwords.txt"
    echo "A) Archive"
    echo "?) More info"
    echo "q) Quit "

    
    # echo "f) Save note (manual name)"
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

name_manual() {
    read -p "Enter filename: " name
    mv -i "$FILE" "$HABEO/$name"
    touch "$FILE"
    echo "Saved as $HABEO/$name"
}

edit_buffer() {
    $EDITOR_CMD "$FILE"
}

save_auto() {
    name=$(auto_name)
    echo "Save as $name? (y/n/a)"
    #    read -p "> " c
    IFS= read -rsn1 c

    if [ "$c" = 'y' ]; then
        mv -i "$FILE" "$HABEO/$name"
        touch "$FILE"
        echo "Saved as $HABEO/$name"
    elif [ "$c" = 'n' ]; then
        name_manual
    elif [ "$c" = 'a' ]; then
	echo "$name" >> "$STOPWORDS"
	echo "appended $name to stopwords"
    else
        echo "?"
    fi
    pause
}

save_manual() {
    name_manual
    pause
}

edit_archive() {
    cd "$HABEO"
    chosenFile=$(ls --sort time | fzf)
    [ -n "$chosenFile" ] && $EDITOR_CMD "$chosenFile"
    pause
}

print_archive() {
    cd "$HABEO"
    chosenFile=$(ls --sort time | fzf)
    [ -n "$chosenFile" ] && less "$chosenFile"
    pause
}

spell_check() {
    ispell "$FILE"
    pause
}

delete_buffer() {
    rm -i "$FILE"
    touch "$FILE"
    echo "Current note reset."
    pause
}

encrypt_file() {
    
    chosenFile=$(ls --sort time | fzf)

    GPG_TTY=$(tty)
    export GPG_TTY
    gpg --pinentry-mode loopback --symmetric "$chosenFile"
    rm -i "$chosenFile"
}

edit_stopwords() {
    $EDITOR_CMD "$STOPWORDS"
}

archive_notes() {
    cd "$HABEO"
    tar -czf archive.tar.gz *
    cp archive.tar.gz "$BACKUP/archive.tar.gz"
    
    echo "Archived to archive.tar.gz"
    echo "Saved to $BACKUP"


    pause
}

while true; do
    display_menu
    IFS= read -rsn1 choice
    case "$choice" in
        e) edit_buffer ;;
        s) save_auto ;;
        f) save_manual ;;
        E) edit_archive ;;
        P) print_archive ;;
        i) spell_check ;;
        d) delete_buffer ;;
        X) encrypt_file ;;
        w) edit_stopwords ;;
        A) archive_notes ;;
        q) break ;;
        *) echo "Invalid choice."; pause ;;
    esac
done

exit 0
