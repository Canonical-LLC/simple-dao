set -eux

cardano-cli transaction hash-script-data --script-data-value "[{ \"bytes\": \"$1\" }, { \"int\" : $2 }]"
