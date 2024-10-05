#!/bin/bash



#vars

url=$1

HTML_CONTENT=$(curl -s "$url")


modo_uso(){

	echo "
	Modo de Uso

	$0 http/https://exemplo.com
	
	"

}


valida_argumentos(){

	#verificação qtd argumentos
	if [ $# -ne 1 ]; then 
		modo_uso 
		exit 1
	fi

	#verificação url
	if [[ ! $url =~ ^https?:// ]]; then

		echo "A URL fornecida é inválida"
		exit 1
	fi
}


captura_link(){

	echo -e "\n==== Capturando Links =====\n"
	echo "$HTML_CONTENT" | grep -Eo '(http|https)://[^"]+' | sort -u

}


captura_scripts(){

	echo -e "\n==== Capturando scritps====\n "

	echo "$HTML_CONTENT" | grep -Eo '<script[^>]+src="[^"]+"'  | sed -E 's/.*src="([^"]+)".*/\1/'
}


captura_comentarios(){

	echo -e "\n==== Capturando comentários HTML ====\n"

    if ! echo "$HTML_CONTENT" | grep -oE '<!--.*-->' | sed 's/<!--//; s/-->//' ; then
		echo "comentários não encontrados"
	else
		echo "$HTML_CONTENT" | grep -oE '<!--.*-->' | sed 's/<!--//; s/-->//'
	fi
}

captura_forms() {

    echo -e "\n=== Extracting Forms ===\n"
	
	forms=$(echo "$HTML_CONTENT" | grep -iEo '<form[^>]+>')

	if [ -z $forms]; then
		echo "Forms não encontrados"
	else	
		echo "$forms" | while read -r form; do
    	    echo "Form action: $(echo "$form" | grep -oE 'action="[^"]+"' | sed 's/action=//' | tr -d '"')"
    	    echo "Form method: $(echo "$form" | grep -oE 'method="[^"]+"' | sed 's/method=//' | tr -d '"')"
    	done
	fi
}

main(){

	valida_argumentos "$@"
	captura_link 
	captura_scripts
	captura_comentarios
	captura_forms
}

main "$@"