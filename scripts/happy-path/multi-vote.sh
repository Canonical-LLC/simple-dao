set -eux

thisDir=$(dirname "$0")
baseDir=$thisDir/../
tempDir=$baseDir/../temp

mkdir -p $tempDir

nftPolicyId=380eab015ac8e52853df3ac291f0511b8a1b7d9ee77248917eaeef10

voter1Address=$(cat ~/$BLOCKCHAIN_PREFIX/voter1.addr)
voter1SigningKey=~/$BLOCKCHAIN_PREFIX/voter1.skey
voter1NFT=$nftPolicyId.12
voter1Input=$(cardano-cli-balance-fixer input --address $voter1Address $BLOCKCHAIN)

voter2Address=$(cat ~/$BLOCKCHAIN_PREFIX/voter2.addr)
voter2SigningKey=~/$BLOCKCHAIN_PREFIX/voter2.skey
voter2NFT=$nftPolicyId.23
voter2Input=$(cardano-cli-balance-fixer input --address $voter2Address $BLOCKCHAIN)

voter3Address=$(cat ~/$BLOCKCHAIN_PREFIX/voter3.addr)
voter3SigningKey=~/$BLOCKCHAIN_PREFIX/voter3.skey
voter3NFT=$nftPolicyId.34
voter3Input=$(cardano-cli-balance-fixer input --address $voter3Address $BLOCKCHAIN)

voter4Address=$(cat ~/$BLOCKCHAIN_PREFIX/voter4.addr)
voter4SigningKey=~/$BLOCKCHAIN_PREFIX/voter4.skey
voter4NFT=$nftPolicyId.45
voter4Input=$(cardano-cli-balance-fixer input --address $voter4Address $BLOCKCHAIN)

voter5Address=$(cat ~/$BLOCKCHAIN_PREFIX/voter5.addr)
voter5SigningKey=~/$BLOCKCHAIN_PREFIX/voter5.skey
voter5NFT=$nftPolicyId.56
voter5Input=$(cardano-cli-balance-fixer input --address $voter5Address $BLOCKCHAIN)

voter6Address=$(cat ~/$BLOCKCHAIN_PREFIX/voter6.addr)
voter6SigningKey=~/$BLOCKCHAIN_PREFIX/voter6.skey
voter6NFT=$nftPolicyId.67
voter6Input=$(cardano-cli-balance-fixer input --address $voter6Address $BLOCKCHAIN)

voter7Address=$(cat ~/$BLOCKCHAIN_PREFIX/voter7.addr)
voter7SigningKey=~/$BLOCKCHAIN_PREFIX/voter7.skey
voter7NFT=$nftPolicyId.78
voter7Input=$(cardano-cli-balance-fixer input --address $voter7Address $BLOCKCHAIN)

voter8Address=$(cat ~/$BLOCKCHAIN_PREFIX/voter8.addr)
voter8SigningKey=~/$BLOCKCHAIN_PREFIX/voter8.skey
voter8NFT=$nftPolicyId.89
voter8Input=$(cardano-cli-balance-fixer input --address $voter8Address $BLOCKCHAIN)

voter9Address=$(cat ~/$BLOCKCHAIN_PREFIX/voter9.addr)
voter9SigningKey=~/$BLOCKCHAIN_PREFIX/voter9.skey
voter9NFT=$nftPolicyId.90
voter9Input=$(cardano-cli-balance-fixer input --address $voter9Address $BLOCKCHAIN)

feePayerAddress=$(cat ~/$BLOCKCHAIN_PREFIX/feePayer.addr)
feePayerSigningKey=~/$BLOCKCHAIN_PREFIX/feePayer.skey

bodyFile=$tempDir/lock-tx-body.01
outFile=$tempDir/lock-tx.01
changeOutput=$(cardano-cli-balance-fixer change --address $feePayerAddress $BLOCKCHAIN)

extraOutput=""
if [ "$changeOutput" != "" ];then
  extraOutput="+ $changeOutput"
fi

cardano-cli transaction build \
    --alonzo-era \
    $BLOCKCHAIN \
    $(cardano-cli-balance-fixer input --address $feePayerAddress $BLOCKCHAIN) \
    $voter1Input \
    $voter2Input \
    $voter3Input \
    $voter4Input \
    $voter5Input \
    $voter6Input \
    $voter7Input \
    $voter8Input \
    $voter9Input \
    --tx-out "$voter1Address + 1758582 lovelace + 1 $voter1NFT" \
    --tx-out-datum-hash $($baseDir/hash-value.sh 1) \
    --tx-out "$voter2Address + 1758582 lovelace + 1 $voter2NFT" \
    --tx-out-datum-hash $($baseDir/hash-value.sh 1) \
    --tx-out "$voter3Address + 1758582 lovelace + 1 $voter3NFT" \
    --tx-out-datum-hash $($baseDir/hash-value.sh 1) \
    --tx-out "$voter4Address + 1758582 lovelace + 1 $voter4NFT" \
    --tx-out-datum-hash $($baseDir/hash-value.sh 1) \
    --tx-out "$voter5Address + 1758582 lovelace + 1 $voter5NFT" \
    --tx-out-datum-hash $($baseDir/hash-value.sh 2) \
    --tx-out "$voter6Address + 1758582 lovelace + 1 $voter6NFT" \
    --tx-out-datum-hash $($baseDir/hash-value.sh 2) \
    --tx-out "$voter7Address + 1758582 lovelace + 1 $voter7NFT" \
    --tx-out-datum-hash $($baseDir/hash-value.sh 3) \
    --tx-out "$voter8Address + 1758582 lovelace + 1 $voter8NFT" \
    --tx-out-datum-hash $($baseDir/hash-value.sh 3) \
    --tx-out "$voter9Address + 1758582 lovelace + 1 $voter9NFT" \
    --tx-out-datum-hash $($baseDir/hash-value.sh 4) \
    --tx-out "$feePayerAddress + 1758582 lovelace $extraOutput" \
    --change-address $feePayerAddress \
    --protocol-params-file scripts/$BLOCKCHAIN_PREFIX/protocol-parameters.json \
    --out-file $bodyFile

echo "saved transaction to $bodyFile"

cardano-cli transaction sign \
    --tx-body-file $bodyFile \
    --signing-key-file $voter1SigningKey \
    --signing-key-file $voter2SigningKey \
    --signing-key-file $voter3SigningKey \
    --signing-key-file $voter4SigningKey \
    --signing-key-file $voter5SigningKey \
    --signing-key-file $voter6SigningKey \
    --signing-key-file $voter7SigningKey \
    --signing-key-file $voter8SigningKey \
    --signing-key-file $voter9SigningKey \
    --signing-key-file $feePayerSigningKey \
    $BLOCKCHAIN \
    --out-file $outFile

echo "signed transaction and saved as $outFile"

cardano-cli transaction submit \
 $BLOCKCHAIN \
 --tx-file $outFile

echo "submitted transaction"

echo
