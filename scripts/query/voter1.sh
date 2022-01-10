set -eux

thisDir=$(dirname "$0")
baseDir=$thisDir/../

$thisDir/find-utxo.sh voter1
