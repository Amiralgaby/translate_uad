#!/bin/sh

OUTPUT_DIR=out
OUTPUT_FILE=uad_lists_fr.json

OUTPUT_PATHFILE="$OUTPUT_DIR"/"$OUTPUT_FILE"

echo "[$(cat translate_part/*)]" > "$OUTPUT_PATHFILE"
sed -i 's/}/},/g' "$OUTPUT_PATHFILE"
sed -i 's/},]/}]/g' "$OUTPUT_PATHFILE"
