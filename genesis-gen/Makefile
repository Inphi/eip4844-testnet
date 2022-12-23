.PHONY: default
default: genesis.ssz ;

GETH=./geth
GETH_DATADIR := $(shell mktemp -d)
BEACON_GEN_EDIT=./beacon-genesis-edit
BEACON_CONFIG=./config.yml
SECONDS_TILL_GENESIS=500

export BEACON_CONFIG
export SECONDS_TILL_GENESIS

geth_genesis.json: base_genesis.json src/GenDeposit.sol
	forge build
	./make-genesis.sh

genesis.ssz: geth_genesis.json deposit_data.json
	./genssz.sh

clean:
	rm -f geth_genesis.json genesis.ssz
