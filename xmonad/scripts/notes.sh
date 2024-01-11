#!/bin/bash

NOTES_DIR=${NOTES_DIR:-$HOME/.local/notes}

menu() {
    rofi -dmenu -p "$1" -theme $HOME/.config/rofi/launcher/nord.rasi
}

menu_force() {
    rofi -dmenu -p "$1" -only-match -no-custom -theme $HOME/.config/rofi/launcher/nord.rasi
}

menu_move() {
    rofi -dmenu -p "$1" -theme $HOME/.config/rofi/launcher/nord.rasi
}

show_notes() {
    pwd=$(pwd)
    cd "$NOTES_DIR" || exit 1
    find . -name "*.md" -printf "%T@ %p\n" |\
        sort -rn |\
        sed "s/^.\{24\}//" |\
        sed s/.md$// |\
        awk \!/README/ |\
        menu "$1"
    cd "$pwd" || exit 1
}

# Convert most strings I care about into snake case file names
# Eg "Foo Bar, Baz! " => "foo_bar_baz"
into_snake_case() {
    echo "$@" |\
        sed "s/[^a-zA-Z0-9_ ]//g" |\
        sed "s/^  *//" |\
        sed "s/  *$//" |\
        sed "s/  */_/g" |\
        tr '[:upper:]' '[:lower:]'
}

main_menu() {
    # Show available notes files
    if ! note=$(show_notes notes); then
        exit 1
    fi

    sc=$(into_snake_case "$note")

    # Exit if no input
    if [[ -z $sc ]]; then
        exit 1
    fi

    file_name="$sc.md"

    file="$NOTES_DIR/$file_name"

    # Create a new file and edit it if it's not present
    # Else, as for action
    if [[ ! -f $file ]]; then
        echo -e "# $note" > "$file"
    else
        action=$(echo -e "open\ndelete\nmove" | menu_force "$note")
        case $action in
            "open") nvim "$NOTES_DIR/$file_name" ;;
            "move")
                confirm=$(menu_move "move")
                # case $confirm in
                #     "yes") rm "$file";;
                # esac;;
				mv "$file" "$HOME/$confirm";;
				
				"delete")
                confirm=$(echo -e "yes\nno" | menu_force "confirm")
                case $confirm in
                    "yes") rm "$file";;
                esac
        esac
    fi
}

main_menu
