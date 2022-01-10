#!/usr/bin/env bash

set -eux
mkdir -p scripts/temp/
mkdir -p ~/$BLOCKCHAIN_PREFIX
./scripts/wallets/make-wallet-and-pkh.sh voter1
./scripts/wallets/make-wallet-and-pkh.sh voter2
./scripts/wallets/make-wallet-and-pkh.sh voter3
./scripts/wallets/make-wallet-and-pkh.sh voter4
./scripts/wallets/make-wallet-and-pkh.sh voter5
./scripts/wallets/make-wallet-and-pkh.sh voter6
./scripts/wallets/make-wallet-and-pkh.sh voter7
./scripts/wallets/make-wallet-and-pkh.sh voter8
./scripts/wallets/make-wallet-and-pkh.sh voter9
./scripts/wallets/make-wallet-and-pkh.sh feePayer
./scripts/wallets/make-wallet-and-pkh.sh proposal
