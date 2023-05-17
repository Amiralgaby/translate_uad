# Translator of uad_list.json

This project enable UAD to have his list translated

# How it works ?

the file **2_trans.sh** translate using **deep-translator** [(package via pip)](https://pypi.org/project/deep-translator/) and the command tool **jq** [(repository)](https://stedolan.github.io/jq/download/)

# Usage

```sh
USAGE : ./2_trans.sh <FILE> <LANG>

The file is always the first argument.

The second argument is the lang.

FILE:
	json file to translate
LANG:
	lang in two letters
  exemple : 
            "fr"
            "it"
            "de"
```

# Concat and create valid json

When the file is translated, it will no works as a valid JSON.

Modify and use contact_json.sh

This script will add "\[" and "]" and concat all files into one file.

Then it add coma after each "}"

Finally it remove the last coma "},]" -> "}]"
