GETH=./geth
GETH_DATADIR=$(shell mktemp -d)
GENESIS_TIME=$(shell date '+%s')
BEACON_GEN=./gen-beacon-genesis
BEACON_GEN_EDIT=./beacon-genesis-edit

geth_genesis.json: base_genesis.json src/GenDeposit.sol
	forge build
	./make-genesis.sh

genesis.ssz: geth_genesis.json deposit-data-1657723220.json
	${GETH} --datadir ${GETH_DATADIR} init ./geth_genesis.json
	$(eval GENESIS_HASH := $(shell ${GETH} -datadir ${GETH_DATADIR} console --exec 'web3.eth.getBlockByNumber("0x0")["hash"]'))
	${BEACON_GEN} --output-ssz=./genesis.tmp.ssz --deposit-json-file ./deposit-data-1657723220.json --config-name eip4844
	${BEACON_GEN_EDIT} -file ./genesis.tmp.ssz  -genesis-time ${GENESIS_TIME} -eth1-blockhash ${GENESIS_HASH}
	mv ./genesis.tmp.ssz ./genesis.ssz
