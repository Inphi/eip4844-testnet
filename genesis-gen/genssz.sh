#!/usr/bin/env bash

set -xEeuo pipefail

GETH=./geth
GETH_DATADIR=$(mktemp -d)
BEACON_GEN_EDIT=./beacon-genesis-edit

if [ ! -f ./genesis_time.txt ]; then
    echo "genesis_time.txt file is missing. Have you run make-genesis.sh?"
    exit 1
fi
GENESIS_TIME=$(cat ./genesis_time.txt)

./prysmctl testnet generate-genesis\
    --chain-config-file $BEACON_CONFIG\
    --deposit-json-file ./deposit_data.json\
    --genesis-time $GENESIS_TIME\
    --output-ssz ./genesis.tmp.ssz\
    --num-validators 5

${GETH} --datadir ${GETH_DATADIR} init ./geth_genesis.json
GENESIS_HASH=$($GETH --datadir ${GETH_DATADIR} console --exec 'web3.eth.getBlockByNumber("0x0")["hash"]' | sed 's/"//g')

${BEACON_GEN_EDIT} -file ./genesis.tmp.ssz -eth1-blockhash ${GENESIS_HASH}
mv ./genesis.tmp.ssz ./genesis.ssz
