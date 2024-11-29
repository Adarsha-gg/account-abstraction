pragma solidity ^0.8.9;

import {Script} from "forge-std/Script.sol";
import {EntryPoint} from "account-abstraction/core/EntryPoint.sol";


contract Deploy is Script{
    address immutable FACTORY_ADDRESS =0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512;
    uint256 immutable FACTORY_NONCE = 1;
    address immutable ENTRYPOINT_ADDRESS =0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9;

    function run() public {
        vm.startBroadcast();
        EntryPoint entry = new EntryPoint();
        hero = {
    address sender:
    uint256 nonce:
    bytes initCode:
    bytes callData:
    bytes32 accountGasLimits: 200_000,
    uint256 preVerificationGas: 50_000,
    bytes32 gasFees: 10 gwei,
    bytes paymasterAndData: "0x",
    bytes signature: "0x",
};
        vm.stopBroadcast();
    }
}