// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import { DepositContract } from "../src/DepositContract.sol";

contract GenDeposit is Script {
    DepositContract dc;
    uint64 constant GWEI = 1000000000;

    function setUp() public {
        dc = new DepositContract();
    }

    // [{"pubkey": "8abfc6fe54c89651f4779c66cb8777155479e18f9d2d7a004e2f51ec97a7e0a1f9a23acd6556ec543fc18fb6f2d83c33", "withdrawal_credentials": "003f4427f9d850597dbbc8d7a9145590e91ad2f74d02d0bce299197596828f52", "amount": 32000000000, "signature": "a6b9536c29a9935f4d1736ec7d9671758ef85a3f25728eb79e23ea175aa3e68e80091701cbbb6732699e17fd7bb5176a0280df41f77cc1791ae3d844a7d15f69dc86230c3e53b5f7ece976a07692a36eac3e2648ce07b5e79384af6ed5e1542d", "deposit_message_root": "4616b632983bafabef0a93da95cc8da66deee98796ae7b513d589d1598578c35", "deposit_data_root": "7ffb2ad21bae18840d9c97b542385ebac90cb9f4f376cbb57bcb0e14da6f0069", "fork_version": "00000ffd", "network_name": "eip4844", "deposit_cli_version": "2.2.0"}, {"pubkey": "b03edee60d4cceeb430d5be3849c785ec489029043fd9fb52aa58f0eb885c7889e61dda6ec52173313f5312c6959ee08", "withdrawal_credentials": "00c9299b69cfe2549b8f6431b3508220ffbdf6fede5de3742de4e69afba45a0e", "amount": 32000000000, "signature": "9004524c827f705e5c2be296e1a6cd7db6da97936c20580e18624f436411dbdbcdaf6755ddc0c867d3bca1b6ab0448800efb93edc278ee3c3c9104678e0fd6eb92382df17230a4a284281764688be9f3eb1cf3ffb59513fe6b355467bb0ee14e", "deposit_message_root": "ecadf1440d7541edb2ab7c24058debbef660672cca581c3318b447fd2b082d91", "deposit_data_root": "12d66a944bc1546b995e81f7b1ff853694e144f21b07459cc9c337e096b2e133", "fork_version": "00000ffd", "network_name": "eip4844", "deposit_cli_version": "2.2.0"}]
    function run() public {
        bytes memory pubkey = hex"8abfc6fe54c89651f4779c66cb8777155479e18f9d2d7a004e2f51ec97a7e0a1f9a23acd6556ec543fc18fb6f2d83c33";
        bytes memory withdrawal_credentials = hex"003f4427f9d850597dbbc8d7a9145590e91ad2f74d02d0bce299197596828f52";
        bytes memory signature = hex"a6b9536c29a9935f4d1736ec7d9671758ef85a3f25728eb79e23ea175aa3e68e80091701cbbb6732699e17fd7bb5176a0280df41f77cc1791ae3d844a7d15f69dc86230c3e53b5f7ece976a07692a36eac3e2648ce07b5e79384af6ed5e1542d";
        run_deposit(pubkey, withdrawal_credentials, signature, 32000000000);

        pubkey = hex"b03edee60d4cceeb430d5be3849c785ec489029043fd9fb52aa58f0eb885c7889e61dda6ec52173313f5312c6959ee08";
        withdrawal_credentials = hex"00c9299b69cfe2549b8f6431b3508220ffbdf6fede5de3742de4e69afba45a0e";
        signature = hex"9004524c827f705e5c2be296e1a6cd7db6da97936c20580e18624f436411dbdbcdaf6755ddc0c867d3bca1b6ab0448800efb93edc278ee3c3c9104678e0fd6eb92382df17230a4a284281764688be9f3eb1cf3ffb59513fe6b355467bb0ee14e";
        run_deposit(pubkey, withdrawal_credentials, signature, 32000000000);

        for (uint i = 0; i < 32; i++) {
            bytes32 slot = vm.load(address(dc), bytes32(i));
            if (slot != bytes32(0)) {
                console.logBytes32(slot);
            } else if (i > 1) {
                revert("unexpected non-zero value in slot > 1");
            }
        }

        bytes32 count = vm.load(address(dc), bytes32(uint256(32)));
        if (uint256(count) != 2) {
            revert("invalid number of deposits");
        }
    }

    function run_deposit(bytes memory pubkey, bytes memory withdrawal_credentials, bytes memory signature, uint64 amount) internal {
        bytes32 node = encode_node(pubkey, withdrawal_credentials, signature, to_little_endian_64(amount));
        dc.deposit{value: uint256(amount) * GWEI}(pubkey, withdrawal_credentials, signature, node);
    }

    function slice(bytes memory a, uint32 offset, uint32 size) pure internal returns (bytes memory result) {
        result = new bytes(size);
        for (uint i = 0; i < size; i++) {
            result[i] = a[offset + i];
        }
    }

    function encode_node(bytes memory pubkey, bytes memory withdrawal_credentials, bytes memory signature, bytes memory amount) public pure returns (bytes32) {
        bytes16 zero_bytes16;
        bytes24 zero_bytes24;
        bytes32 zero_bytes32;
        bytes32 pubkey_root = sha256(abi.encodePacked(pubkey, zero_bytes16));
        bytes32 signature_root = sha256(abi.encodePacked(
            sha256(abi.encodePacked(slice(signature, 0, 64))),
            sha256(abi.encodePacked(slice(signature, 64, 32), zero_bytes32))
        ));
        return sha256(abi.encodePacked(
            sha256(abi.encodePacked(pubkey_root, withdrawal_credentials)),
            sha256(abi.encodePacked(amount, zero_bytes24, signature_root))
        ));
    }

    function to_little_endian_64(uint64 value) internal pure returns (bytes memory ret) {
        ret = new bytes(8);
        ret[0] = bytes1(uint8(value & 0xff));
        ret[1] = bytes1(uint8((value >> 8) & 0xff));
        ret[2] = bytes1(uint8((value >> 16) & 0xff));
        ret[3] = bytes1(uint8((value >> 24) & 0xff));
        ret[4] = bytes1(uint8((value >> 32) & 0xff));
        ret[5] = bytes1(uint8((value >> 40) & 0xff));
        ret[6] = bytes1(uint8((value >> 48) & 0xff));
        ret[7] = bytes1(uint8((value >> 56) & 0xff));
    }
}
