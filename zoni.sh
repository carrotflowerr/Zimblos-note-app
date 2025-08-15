#!/bin/bash

<<<<<<< HEAD
# Hyper-minimal note manager
# Written by: Zimblo
# Source:  github.com/carrotflowerr
=======
# Simple text interface for note script
# TODO:
## Restore old archive function
## Write help menu
## making default file markdown might be beneficial. 
>>>>>>> 6eaae160a6f7ae09667d97d94aaae4719db281c6

HABEO="$HOME/.note"
BACKUP="$HOME/Documents"
STOPWORDS="$HABEO/.stopwords.txt"
TIME_FORMAT="%Y%m%d_%H%M%S"
EDITOR_CMD="ed"
#EDITOR_CMD="${EDITOR:-ed}"
STATE_FILE="$HABEO/.buffers"

mkdir -p "$HABEO"

BUFFERS=()
CURRENT=0

# Load state
if [ -f "$STATE_FILE" ]; then
    mapfile -t STATE_LINES < "$STATE_FILE"
    BUFFERS=("${STATE_LINES[@]:0:${#STATE_LINES[@]}-1}")
    CURRENT=${STATE_LINES[-1]}
else
    FILE="/tmp/note_$(date +%s%N)"
    touch "$FILE"
    BUFFERS+=("$FILE")
    CURRENT=1
fi

persist_state() {
    printf "%s\n" "${BUFFERS[@]}" > "$STATE_FILE"
    echo "$CURRENT" >> "$STATE_FILE"
}

new_buffer() {
    FILE="/tmp/note_$(date +%s%N)"
    touch "$FILE"
    BUFFERS+=("$FILE")
    CURRENT=${#BUFFERS[@]}
    persist_state
}

file_check() {
    for i in "${!BUFFERS[@]}"; do
        f="${BUFFERS[$i]}"
        if [ -s "$f" ]; then
            mark="[X]"
        else
            mark="[]"
        fi
        if [ $((i+1)) -eq $CURRENT ]; then
            printf "*%s* " "$mark"
        else
            printf "%s " "$mark"
        fi
    done
    echo
}

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
<<<<<<< HEAD
    file_check
    echo "---------------------"
    echo "e) Edit"
    echo "s) Save (auto)"
    echo "f) Save (manual)"
    echo "d) Delete buffer"
    echo "n) New tmp buffer"
    echo "---------------------"
    echo "E) Edit archive"
    echo "P) Print archive"
    echo "---------------------"
    echo "i) Spell-check"
    echo "X) Encrypt file"
    echo "---------------------"
    echo "w) Edit stopwords"
    echo "A) Archive notes"
    echo "q) Quit"
=======
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
>>>>>>> 6eaae160a6f7ae09667d97d94aaae4719db281c6
}

pause() { read -p "Press Enter to continue..."; }

auto_name() {
    fname=$(tr '[:upper:]' '[:lower:]' < "${BUFFERS[CURRENT-1]}" |
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
<<<<<<< HEAD
    mv -i "${BUFFERS[CURRENT-1]}" "$HABEO/$name.note"
    touch "${BUFFERS[CURRENT-1]}"
    persist_state
    echo "Saved as $HABEO/$name.note"
}

edit_buffer() { $EDITOR_CMD "${BUFFERS[CURRENT-1]}"; persist_state; }
save_auto() {
    name=$(auto_name)
    echo "Save as $name? (y/n/a)"
    IFS= read -rsn1 c
    if [ "$c" = 'y' ]; then
        mv -i "${BUFFERS[CURRENT-1]}" "$HABEO/$name.note"
        touch "${BUFFERS[CURRENT-1]}"
        echo "Saved as $HABEO/$name.note"
    elif [ "$c" = 'n' ]; then
        name_manual
    elif [ "$c" = 'a' ]; then
        echo "$name" >> "$STOPWORDS"
        echo "Appended $name to stopwords"
    else
        echo "?"
    fi
    persist_state
    pause
}

# I know this is aids.
save_manual() { name_manual; pause; }
edit_archive() { cd "$HABEO"; chosenFile=$(ls --sort time | fzf); [ -n "$chosenFile" ] && $EDITOR_CMD "$chosenFile"; pause; }
print_archive() { cd "$HABEO"; chosenFile=$(ls --sort time | fzf); [ -n "$chosenFile" ] && less "$chosenFile"; pause; }
spell_check() { ispell "${BUFFERS[CURRENT-1]}"; pause; }
delete_buffer() { rm -i "${BUFFERS[CURRENT-1]}"; touch "${BUFFERS[CURRENT-1]}"; echo "Current note reset."; persist_state; pause; }
encrypt_file() { chosenFile=$(ls --sort time | fzf); GPG_TTY=$(tty); export GPG_TTY; gpg --pinentry-mode loopback --symmetric "$chosenFile"; rm -i "$chosenFile"; }
edit_stopwords() { $EDITOR_CMD "$STOPWORDS"; }
archive_notes() { cd "$HABEO"; tar -czf archive.tar.gz *; cp archive.tar.gz ~/Documents/noteArchive.tar.gz; echo "Archived."; pause; }
=======
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
>>>>>>> 6eaae160a6f7ae09667d97d94aaae4719db281c6

while true; do
    display_menu
    IFS= read -rsn1 choice
    case "$choice" in
        e) edit_buffer ;;
        s) save_auto ;;
        f) save_manual ;;
<<<<<<< HEAD
        d) delete_buffer ;;
        n) new_buffer ;;
        E) edit_archive ;;
        P) print_archive ;;
        i) spell_check ;;
        X) encrypt_file ;;
        w) edit_stopwords ;;
        A) archive_notes ;;
        [1-9])
            if [ "$choice" -le "${#BUFFERS[@]}" ]; then CURRENT=$choice; persist_state; fi ;;
        q) persist_state; break ;;
=======
        E) edit_archive ;;
        P) print_archive ;;
        i) spell_check ;;
        d) delete_buffer ;;
        X) encrypt_file ;;
        w) edit_stopwords ;;
        A) archive_notes ;;
        q) break ;;
>>>>>>> 6eaae160a6f7ae09667d97d94aaae4719db281c6
        *) echo "Invalid choice."; pause ;;
    esac

done

exit 0
