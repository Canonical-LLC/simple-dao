#!/usr/bin/env bash

set -eu

thisDir=$(dirname "$0")
baseDir=$thisDir/../
tempDir=$baseDir/../temp

mkdir -p $tempDir


proposerAddress=$1
proposerSigningKey=$2
expiration=$3
url=$4


bodyFile=$tempDir/lock-tx-body.01
outFile=$tempDir/lock-tx.01
changeOutput=$(cardano-cli-balance-fixer change --address $proposerAddress $BLOCKCHAIN)

extraOutput=""
if [ "$changeOutput" != "" ];then
  extraOutput="+ $changeOutput"
fi

metadataFile=$tempDir/metadata.json

cat << EOF > $metadataFile
{
  "1" : {
    "url" : "$url",
    "expiration": $expiration
  }
}
EOF

cardano-cli transaction build \
    --alonzo-era \
    $BLOCKCHAIN \
    $(cardano-cli-balance-fixer input --address $proposerAddress $BLOCKCHAIN) \
    --tx-out "$proposerAddress + 1744798 lovelace $extraOutput" \
    --change-address $proposerAddress \
    --metadata-json-file $metadataFile \
    --protocol-params-file scripts/$BLOCKCHAIN_PREFIX/protocol-parameters.json \
    --out-file $bodyFile

cardano-cli transaction sign \
    --tx-body-file $bodyFile \
    --signing-key-file $proposerSigningKey \
    $BLOCKCHAIN \
    --out-file $outFile

cardano-cli transaction submit \
 $BLOCKCHAIN \
 --tx-file $outFile

cardano-cli transaction txid --tx-body-file $bodyFile
