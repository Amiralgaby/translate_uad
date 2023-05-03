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
	if [ "${#1}" -ge 5000 ]; then
		echo "plus de 5000 caractères"
	else
		c="$(dt -trans "google" -src en -tg "$2" -txt "$1"| sed '1d;2d')"
		
		echo "${c#Translation result: }"
	fi
}

save_translation() {
	jq ".[$1]"' | .description = "'"${3//\"/\\\"}"'"' "$2" > "./translate_part/trad_$1.json"
}

[ -f "$1" ] || usage 1

tgt="fr"

if [ -n "$2" ]; then
	tgt="$2"
fi

TRANS=""

total_index=$(jq length "$1")

echo "nbLigne à faire : $total_index"

for (( i=0 ; i < total_index ; i++)); do
	TRANS=""
	
	while read -r line; 
	do
		if [ -z "$line" ]; then
			break
		fi

		temp="$(translate_internal "$line" "$tgt")"

		# echo "traduit : $temp"

		TRANS+="${temp# }\n"
	
	done< <(jq -r ".[$i] | .description" "$1")
	
	# echo "desc : $TRANS"
	
	desc_output="${TRANS%\\n}" # on enlève le \n final.

	echo -e "$desc_output"

	save_translation "$i" "$1" "$desc_output"
done


