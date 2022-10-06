#!/usr/bin/env bash

function get_deployed_bytecode() {
    echo $(jq -r .deployedBytecode.object $1)
}

DEPOSIT_CONTRACT_ADDRESS=0x8A04d14125D0FDCDc742F4A05C051De07232EDa4
DEPOSIT_CONTRACT_BYTECODE=$(get_deployed_bytecode out/DepositContract.sol/DepositContract.json)

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
DEPOSIT_CONTRACT_BALANCE=0x3782dace9d9000000

# 100_000 eth
ACCOUNT_BAL=0x152d02c7e14af6800000
ACCOUNT_1=0xBB427322C6C4Ed83cDCA287337AeF5bA734D0110
ACCOUNT_2=0x10F5d45854e038071485AC9e402308cF80D2d2fE
ACCOUNT_3=0x60E61a5b5787aCBDAB431Ac7cAFEB1eFbF9b4d9e

jq ". | .alloc.\"$DEPOSIT_CONTRACT_ADDRESS\".code = \"$DEPOSIT_CONTRACT_BYTECODE\"" < ./base_genesis.json | \
    jq ". | .alloc.\"$DEPOSIT_CONTRACT_ADDRESS\".storage.\"$BRANCH0_SLOT\" = \"$BRANCH0_VAL\"" | \
    jq ". | .alloc.\"$DEPOSIT_CONTRACT_ADDRESS\".storage.\"$BRANCH1_SLOT\" = \"$BRANCH1_VAL\"" | \
    jq ". | .alloc.\"$DEPOSIT_CONTRACT_ADDRESS\".storage.\"$BRANCH2_SLOT\" = \"$BRANCH2_VAL\"" | \
    jq ". | .alloc.\"$DEPOSIT_CONTRACT_ADDRESS\".storage.\"$COUNT_SLOT\" = \"$COUNT_VAL\"" | \
    jq ". | .alloc.\"$DEPOSIT_CONTRACT_ADDRESS\".balance = \"$DEPOSIT_CONTRACT_BALANCE\"" | \
    jq ". | .alloc.\"$ACCOUNT_1\".balance = \"$ACCOUNT_BAL\"" | \
    jq ". | .alloc.\"$ACCOUNT_2\".balance = \"$ACCOUNT_BAL\"" | \
    jq ". | .alloc.\"$ACCOUNT_3\".balance = \"$ACCOUNT_BAL\"" > ./geth_genesis.json
