GETH=./geth
GETH_DATADIR := $(shell mktemp -d)
BEACON_GEN=./gen-beacon-genesis
BEACON_GEN_EDIT=./beacon-genesis-edit

geth_genesis.json: base_genesis.json src/GenDeposit.sol
	forge build
	./make-genesis.sh

genesis.ssz: geth_genesis.json deposit_data.json
	./genssz.sh

clean:
	rm -f geth_genesis.json genesis.ssz
