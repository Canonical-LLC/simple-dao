set -eux

thisDir=$(dirname "$0")
baseDir=$thisDir/../

$thisDir/mint-0-policy.sh 12 voter1
$baseDir/wait/until-next-block.sh
$baseDir/wait/until-next-block.sh
$thisDir/mint-0-policy.sh 23 voter2
$baseDir/wait/until-next-block.sh
$baseDir/wait/until-next-block.sh
$thisDir/mint-0-policy.sh 34 voter3
$baseDir/wait/until-next-block.sh
$baseDir/wait/until-next-block.sh
$thisDir/mint-0-policy.sh 45 voter4
$baseDir/wait/until-next-block.sh
$baseDir/wait/until-next-block.sh
$thisDir/mint-0-policy.sh 56 voter5
$baseDir/wait/until-next-block.sh
$baseDir/wait/until-next-block.sh
$thisDir/mint-0-policy.sh 67 voter6
$baseDir/wait/until-next-block.sh
$baseDir/wait/until-next-block.sh
$thisDir/mint-0-policy.sh 78 voter7
$baseDir/wait/until-next-block.sh
$baseDir/wait/until-next-block.sh
$thisDir/mint-0-policy.sh 89 voter8
$baseDir/wait/until-next-block.sh
$baseDir/wait/until-next-block.sh
$thisDir/mint-0-policy.sh 90 voter9
$baseDir/wait/until-next-block.sh
