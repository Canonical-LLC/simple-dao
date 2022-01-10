set -eux

thisDir=$(dirname "$0")
baseDir=$thisDir/../

$baseDir/happy-path/generic-vote.sh 3 90
