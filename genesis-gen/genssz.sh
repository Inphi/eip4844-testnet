#!/usr/bin/env bash

set -xeu

GETH=./geth
GETH_DATADIR=$(mktemp -d)
BEACON_GEN=./gen-beacon-genesis
BEACON_GEN_EDIT=./beacon-genesis-edit

${GETH} --datadir ${GETH_DATADIR} init ./geth_genesis.json
GENESIS_HASH=$($GETH --datadir ${GETH_DATADIR} console --exec 'web3.eth.getBlockByNumber("0x0")["hash"]' | sed 's/"//g')
${GETH} --datadir ${GETH_DATADIR} console --exec 'web3.eth.getBlockByNumber("0x0")["hash"]'
${BEACON_GEN} --output-ssz=./genesis.tmp.ssz --deposit-json-file ./deposit-data-1657723220.json --config-name eip4844
${BEACON_GEN_EDIT} -file ./genesis.tmp.ssz -eth1-blockhash ${GENESIS_HASH}
mv ./genesis.tmp.ssz ./genesis.ssz
