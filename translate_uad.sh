#!/bin/bash

usage() {
cat << EOF
USAGE : $0 <FILE> <LANG>

The file is always the first argument.

The second argument is the lang.

FILE:
	json file to translate
LANG:
	lang in two letters like in ["fr", "de", "it", ...]
EOF
exit "$1"
}

translate_internal()  {
	deep-translator translate -src en -tgt "$2" --text "$1" | sed -n '/Translated text:/,$p' | sed '1d'
}

[ -f "$1" ] || usage 1

tgt="fr"

if [ -n "$2" ]; then
	tgt="$2"
fi

i=0
translate_temp=""

cat "$1" | jq -r '.[] | .description' | while read -r line ; 
do
	if [ -z "$line" ]
	then
		echo "$i"

		if [ -n "$translate_temp" ] 
		then
			description_translated="${translate_temp::-2}" # on enlève le \n final.

			# echo -e "$description_translated"

			# update du fichier

			jq ".[$i]"' | .description = "'"${description_translated//\"/\\\"}"'"' "$1" > "trad_$i.json"
		fi
		
		i=$((i+1))

		# echo "Lignes $i totales"

		translate_temp=""
		
		echo "#######"
	else
		temp="$(translate_internal "$line" "$tgt")"

		# echo "$temp"

		# on enlève l'espace en début

		translate_temp+="${temp# }\n"
	fi
done

