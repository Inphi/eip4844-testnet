#!/usr/bin/env bash

set -xeu

GETH=./geth
GETH_DATADIR=$(mktemp -d)
BEACON_GEN=./gen-beacon-genesis
BEACON_GEN_EDIT=./beacon-genesis-edit

# We have 5 mins to setup the beacon node after generation
GENESIS_TIME=$(($(date '+%s')+300))

${GETH} --datadir ${GETH_DATADIR} init ./geth_genesis.json
GENESIS_HASH=$($GETH --datadir ${GETH_DATADIR} console --exec 'web3.eth.getBlockByNumber("0x0")["hash"]' | sed 's/"//g')
${BEACON_GEN}\
    --output-ssz=./genesis.tmp.ssz\
    --deposit-json-file ./deposit_data.json\
    --genesis-time ${GENESIS_TIME}\
    --config-name eip4844
${BEACON_GEN_EDIT} -file ./genesis.tmp.ssz -eth1-blockhash ${GENESIS_HASH}
mv ./genesis.tmp.ssz ./genesis.ssz
