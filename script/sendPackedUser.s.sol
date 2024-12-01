//SPDX-License-Identifier:MIT

pragma solidity 0.8.28;

import {Script} from "forge-std/Script.sol";
import {EthAbstract} from "src/ether/smolaa.sol";

contract DeployEthAbstract is Script{
    function run() public {
        vm.startBroadcast();
        EthAbstract ethAbstract = new EthAbstract(0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9);
        
        vm.stopBroadcast();
    }
    
}
