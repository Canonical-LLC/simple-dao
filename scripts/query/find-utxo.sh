#!/usr/bin/env bash

cardano-cli query utxo --address $(cat ~/$BLOCKCHAIN_PREFIX/$1.addr) $BLOCKCHAIN
