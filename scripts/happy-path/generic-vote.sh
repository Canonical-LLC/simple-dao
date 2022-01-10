set -eux

thisDir=$(dirname "$0")
baseDir=$thisDir/../

$baseDir/core/vote-tx.sh \
  $(cat ~/$BLOCKCHAIN_PREFIX/voter$1.addr) \
  ~/$BLOCKCHAIN_PREFIX/voter$1.skey \
  $($baseDir/hash-value.sh $3 $1) \
  "1744798 lovelace + 1 d6cfdbedd242056674c0e51ead01785497e3a48afbbb146dc72ee1e2.$2"
