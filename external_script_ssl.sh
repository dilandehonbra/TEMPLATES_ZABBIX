#/usr/bin/env bash
# Script para obter informações sobre a validade de certificados SSL/TLS de um determinado servidor web.
# Modos de uso:
# 1. expired_sum: informa em quanto tempo o certificado irá expirar(no template com medida em "segundos").
#    Exemplo de uso: bash certs.sh www.exemplo.com.br expired_sum
# 2. certgen: retorna a data de início da validade do certificado SSL/TLS do servidor.
#    Exemplo de uso: bash certs.sh www.exemplo.com.br certgen
# 3. certs.sh: retorna a data de fim da validade do certificado SSL/TLS do servidor.
#    Exemplo de uso: bash certs.sh www.exemplo.com.br(esse é o uso comum, ou seja, sem parâmeros de manipulação informa a data de expiração do certificado em unixtime.

{ IFS=$'\n'
var=$({
        echo | openssl s_client -connect $1:443 2>/dev/null |\
        openssl x509 -noout -dates
})
var2=$( for i in ${var//GMT/} ; do date -d "${i//not*=/}" +"%s" ; done )

if [[ "$2" == "expired_sum" ]]
        then
        var3=$(echo $(("${var2//[[:space:]]/-}"))) ; echo ${var3:1}
        exit 0
fi

if [[ "$2" == "certgen" ]]
        then head -n1 <<<${var2}
        else tail -n1 <<<${var2}
fi
}
