pragma solidity 0.8.28;

import {Script} from "forge-std/Script.sol";
import {Account} from "src/aa.sol";

contract Deploy2 is Script{

    function run() public {
        vm.startBroadcast();
        // EntryPoint entry = new EntryPoint();
        
        vm.stopBroadcast();
    }
    

    

}