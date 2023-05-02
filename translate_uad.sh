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


traduire_soi_meme=false
i=0
translate_temp=""

jq -r '.[] | .description' "$1" | while read -r line ; 
do
	if [ -z "$line" ]
	then
		echo "$i"

		if [ -n "$translate_temp" ] && [ "$traduire_soi_meme" = false ]
		then
			description_translated="${translate_temp::-2}" # on enlève le \n final.

			# echo -e "$description_translated"

			# update du fichier

			jq ".[$i]"' | .description = "'"${description_translated//\"/\\\"}"'"' "$1" > "./translate_part/trad_$i.json"
		fi

		if [ "$traduire_soi_meme" = true ]; then
			echo "traduire_soi_meme la description n°$i" >> à_traduire_soi_même.txt
		fi

		i=$((i+1))
		
		# echo "Lignes $i totales"

		translate_temp=""
		traduire_soi_meme=false
		echo "#######"
	else

		# pas besoin de faire un appel si je dois traduire soi-même
		if [ "$traduire_soi_meme" = true ]; then
			continue
		fi

		# on doit tester si le string fait plus de 5000 caractères
		# car c'est une contrainte de l'API

		if [ "${#line}" -ge 5000 ]; then
			echo -e "Numéro $i\n$temp\n#####################" >> à_traduire_soi_même.txt
			traduire_soi_meme=true
		fi

		temp="$(translate_internal "$line" "$tgt")"

		# echo "$temp"

		# on enlève l'espace en début

		translate_temp+="${temp# }\n"
	fi
done

