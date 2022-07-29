#!/usr/bin/env bash

function get_deployed_bytecode() {
    echo $(jq -r .deployedBytecode.object $1)
}

DEPOSIT_CONTRACT_ADDRESS=0x8A04d14125D0FDCDc742F4A05C051De07232EDa4
DEPOSIT_CONTRACT_BYTECODE=$(get_deployed_bytecode out/DepositContract.sol/DepositContract.json)

TIME=$(date '+%s')

LOGS=$(forge script GenDeposit --json | grep '"logs"')

# Deposit contract branch[0]
BRANCH0_SLOT=0x0000000000000000000000000000000000000000000000000000000000000000
BRANCH0_VAL=$(echo $LOGS | jq '.logs[0]' | sed 's/"//g')

# Deposit contract branch[1]
BRANCH1_SLOT=0x0000000000000000000000000000000000000000000000000000000000000001
BRANCH1_VAL=$(echo $LOGS | jq '.logs[1]' | sed 's/"//g')

# Deposit contract branch[2]
BRANCH2_SLOT=0x0000000000000000000000000000000000000000000000000000000000000002
BRANCH2_VAL=$(echo $LOGS | jq '.logs[2]' | sed 's/"//g')

# Deposit contract deposit_count
COUNT_SLOT=0x0000000000000000000000000000000000000000000000000000000000000020
COUNT_VAL=0x0000000000000000000000000000000000000000000000000000000000000005
# Deposit contract balance (64 ETH)
BALANCE=0x3782dace9d9000000

jq ". | .alloc.\"$DEPOSIT_CONTRACT_ADDRESS\".code = \"$DEPOSIT_CONTRACT_BYTECODE\"" < ./base_genesis.json | \
    jq ". | .timestamp = \"$TIME\"" | \
    jq ". | .alloc.\"$DEPOSIT_CONTRACT_ADDRESS\".storage.\"$BRANCH0_SLOT\" = \"$BRANCH0_VAL\"" | \
    jq ". | .alloc.\"$DEPOSIT_CONTRACT_ADDRESS\".storage.\"$BRANCH1_SLOT\" = \"$BRANCH1_VAL\"" | \
    jq ". | .alloc.\"$DEPOSIT_CONTRACT_ADDRESS\".storage.\"$BRANCH2_SLOT\" = \"$BRANCH2_VAL\"" | \
    jq ". | .alloc.\"$DEPOSIT_CONTRACT_ADDRESS\".storage.\"$COUNT_SLOT\" = \"$COUNT_VAL\"" | \
    jq ". | .alloc.\"$DEPOSIT_CONTRACT_ADDRESS\".balance = \"$BALANCE\"" > ./geth_genesis.json
