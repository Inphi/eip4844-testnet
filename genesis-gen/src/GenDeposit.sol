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
        bytes memory pubkey = hex"95f29abdf24712416ce1eb490fd3985ed0b9223b5370fe925d9d4ff500a684edd25703f94b0819d562b311656f7963e7";
        bytes memory withdrawal_credentials = hex"008c3eb186346556b0f7b1e580ba8e1d49ea61768dfcc7025d105fb156bb4db6";
        bytes memory signature = hex"b1f7ceb895a027c1a7a94feef7b577e773ace100ff69a7e5aed92e94abaec2b3fe3144828b30aa0ec520388431bdcfca06352b77991197149044befd4747ddb08796168497c77447aaa0e06e26bf7fe68b49c62e0bad69c655e795c8569f6a0c";
        run_deposit(pubkey, withdrawal_credentials, signature, 32000000000);

        pubkey = hex"ab773b0b098d48950ba4fa1c49351639bd9602cae662accd97721f2da1daa86a80fac21c52e1f214d35c958aff9753eb";
        withdrawal_credentials = hex"00b10d24943d3de225eab1f26336706b855d42de0ee0b93bb15885b0797f5990";
        signature = hex"80779655f77104923693a67820087ab20a632dc7e01a1e2128c103c03c0101c5ecb2d32676ae4b1d226aa37e8d88e784014c2048b342eb6ca0332e6844af2b88867f34d2900b5224c264ed1ffbc92244c7167d7cc5b9fb2128d385742197a87b";
        run_deposit(pubkey, withdrawal_credentials, signature, 32000000000);

        pubkey = hex"8ff9c36184271ee997d1ded63079cdca709c86f0e7726d4686bb23490e7fe9944cff03af26ebbd64368cede8e25a0f45";
        withdrawal_credentials = hex"0099e0fd2733ccf0aa250439aed612b7e491b5bb079bd3389b76891a7c59258e";
        signature = hex"8a0a4cb5717205d4d339e5325adf00698270269acebeda853be3669083b2c296e947315b40c401c8f2f1c02d33752f9c062dc88186f5d32a15690ac5f970a77ee9ebf831f9fb1355826af2b5aa06cb44d29d125f19430946d8ab7ff39253003d";
        run_deposit(pubkey, withdrawal_credentials, signature, 32000000000);

        pubkey = hex"af568e5d4ad65f6dcdf62af1cb54fc38b2ac38100bc1031f9899134c640e8b1cf5acf135ee27165b6b40d07ad82c2b1a";
        withdrawal_credentials = hex"00614050f644e6b85d5a98ef5b8819a2b3f4a9156910814ae2b2fd487e2dbb09";
        signature = hex"9102529a662629930ca6626554ac8bcd59a37217230d91a2c13b54b6ab8ff854726a1a69b1341e68cce9ad13e16771b306ab8b56b66980cb3cd0c80757f0860466dca44cb5c52bee85a2798ddd60970b2ec9f31dad9eff8018699beb18804b4c";
        run_deposit(pubkey, withdrawal_credentials, signature, 32000000000);

        pubkey = hex"8becf10b9c9ec0cd609f479b6676e736d3300bf798fd06549c788a3353dc0cb5e23d23f44964c1692d6b31365f60041d";
        withdrawal_credentials = hex"009231c34c0be79cc28d58a5d8be1179842347e3f41d6c8ef3acb3d79b43769d";
        signature = hex"98491500560217e0005e2e15f4e222965f6501c342c19fd67d893c7e51b779f8075436b4432ed36bf09f1260daf7e2d710200f58a09d08f5d1cd24ee9f04f812f4a8367fb940cd3b95ca8daed565a0ceed90f4829893aaaa0c7d6f2830867068";
        run_deposit(pubkey, withdrawal_credentials, signature, 32000000000);

        for (uint i = 0; i < 32; i++) {
            bytes32 slot = vm.load(address(dc), bytes32(i));
            if (slot != bytes32(0)) {
                console.logBytes32(slot);
            } else if (i < 2) {
                revert("unexpected non-zero value in slot < 2");
            }
        }

        bytes32 count = vm.load(address(dc), bytes32(uint256(32)));
        if (uint256(count) != 5) {
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
