set -eux

bodyFile=temp/consolidate-tx-body.01
outFile=temp/consolidate-tx.01
signingKey=~/$BLOCKCHAIN_PREFIX/voter1.skey
senderAddr=$(cat ~/$BLOCKCHAIN_PREFIX/voter1.addr)
receiverAddr=$(cat ~/$BLOCKCHAIN_PREFIX/voter3.addr)

cardano-cli transaction build \
  --alonzo-era \
  $BLOCKCHAIN \
  --tx-in 1ae5a7207c0673f5ca31985ac64f46bf00c637d685c74cec48f00659fdc83e5e#0 \
  --tx-out "$receiverAddr +20000000 lovelace" \
  --change-address $senderAddr \
  --protocol-params-file scripts/$BLOCKCHAIN_PREFIX/protocol-parameters.json \
  --out-file $bodyFile

echo "saved transaction to $bodyFile"

cardano-cli transaction sign \
   --tx-body-file $bodyFile \
   --signing-key-file $signingKey \
   $BLOCKCHAIN \
   --out-file $outFile

echo "signed transaction and saved as $outFile"

cardano-cli transaction submit \
 $BLOCKCHAIN \
 --tx-file $outFile

echo "submitted transaction"
