#!/bin/bash

color="white"

echo -e "\nWorking...\n"

convert -size 16x80 xc:transparent "minislots_font_regular_char_32.png"
for i in $(seq 33 127); do
	char=$(printf "\x$(printf %x $i)")
	if (( $i == 34 )) || (( $i == 92 )); then
		char="\\"$char
	fi

	convert -background none \
		-fill $color \
		-font /usr/share/fonts/truetype/liberation/LiberationSans-Regular.ttf \
		-pointsize 84 \
		 label:"$char" \
		-crop 99x80+0+15 \
		+repage \
		"minislots_font_regular_char_"$i.png
done

convert -size 8x80 xc:transparent "minislots_font_condensed_char_32.png"
for i in $(seq 33 127); do
	char=$(printf "\x$(printf %x $i)")
	if (( $i == 34 )) || (( $i == 92 )); then
		char="\\"$char
	fi

	convert -background none \
		-fill $color \
		-font /usr/share/fonts/truetype/liberation/LiberationSansNarrow-Regular.ttf \
		-pointsize 84 \
		 label:"$char" \
		-crop 99x80+0+15 \
		+repage \
		"minislots_font_condensed_char_"$i.png
done

convert -size 24x80 xc:transparent "minislots_font_bold_char_32.png"
for i in $(seq 33 127); do
	char=$(printf "\x$(printf %x $i)")
	if (( $i == 34 )) || (( $i == 92 )); then
		char="\\"$char
	fi

	convert -background none \
		-fill $color \
		-font /usr/share/fonts/truetype/liberation/LiberationSans-Bold.ttf \
		-pointsize 84 \
		 label:"$char" \
		-crop 99x80+0+15 \
		+repage \
		"minislots_font_bold_char_"$i.png
done

echo -e "\ncopy/paste this to form the char width table:\n\n"

echo "local char_widths = {"
echo -e "\t[32]  = { regular = 16, condensed = 12, bold = 24 },"

for i in $(seq 33 127); do
	echo -en "\t[$i] "
	if [ $i -lt 100 ]; then echo -n " "; fi
	echo -en "= { regular = "$(identify "minislots_font_regular_char_"$i.png|cut -f 3 -d " "|cut -f 1 -d "x")", "
	echo -en "condensed = "$(identify "minislots_font_condensed_char_"$i.png|cut -f 3 -d " "|cut -f 1 -d "x")", "
	echo -e "bold = "$(identify "minislots_font_bold_char_"$i.png|cut -f 3 -d " "|cut -f 1 -d "x")" },"
done

echo "}"
