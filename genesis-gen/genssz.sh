#!/usr/bin/env bash

set -xeu

GETH=./geth
GETH_DATADIR=$(mktemp -d)
BEACON_GEN=./gen-beacon-genesis
BEACON_GEN_EDIT=./beacon-genesis-edit

# We have 8 mins to setup the beacon node after generation
# The beacon chain must be up and running before then to ensure that the 4844 upgrade occurs in time - during the slot the EL hardforks
GENESIS_TIME=$(($(date '+%s')+500))

${GETH} --datadir ${GETH_DATADIR} init ./geth_genesis.json
GENESIS_HASH=$($GETH --datadir ${GETH_DATADIR} console --exec 'web3.eth.getBlockByNumber("0x0")["hash"]' | sed 's/"//g')
${BEACON_GEN}\
    --output-ssz=./genesis.tmp.ssz\
    --deposit-json-file ./deposit_data.json\
    --genesis-time ${GENESIS_TIME}\
    --config-name eip4844
${BEACON_GEN_EDIT} -file ./genesis.tmp.ssz -eth1-blockhash ${GENESIS_HASH}
mv ./genesis.tmp.ssz ./genesis.ssz
