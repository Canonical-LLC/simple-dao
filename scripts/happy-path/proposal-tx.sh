set -eux

thisDir=$(dirname "$0")
baseDir=$thisDir/../

now=$(date +%s)

$baseDir/core/proposal-tx.sh \
  $(cat ~/$BLOCKCHAIN_PREFIX/voter1.addr) \
  ~/$BLOCKCHAIN_PREFIX/voter1.skey \
  $(($now + 10000)) \
  "https//example.com"
