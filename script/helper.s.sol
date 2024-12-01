//SPDX-License-Identifier:MIT

pragma solidity 0.8.28;

import {Script} from "forge-std/Script.sol";
import {EthAbstract} from "src/ether/smolaa.sol";

contract Deploythis is Script{
    error IdNotFound();

    struct NetworkConfig{
        address entryPoint;
    }
    uint256 immutable Sepolia = 11156111;
    uint256 immutable Eth_Mainnet = 1;
    uint256 immutable Polygon = 137;
    uint256 immutable ZkSync = 300;
    

    NetworkConfig public allNetworkConfig; 
    mapping(uint256 =>  NetworkConfig) public networkConfigs; //to get specific netwrok config

    constructor(){
        networkConfigs[Sepolia] = getSepolia();   //setting default network config
    }

    function getConfig() public returns (NetworkConfig memory){
        return getByChainId(block.chainid);   //pass the chain id and get return the config
    }

    function getByChainId(uint256 chainId) public returns (NetworkConfig memory){
        if (chainId = 1){
            return networkConfigs[Eth_Mainnet];
        }
        else if (chainId = 137){
            return networkConfigs[Polygon];
        }
        else if (chainId = 300){
            return networkConfigs[ZkSync];
        }
        else{
            return getAnvil();
        }
    }

    function getSepolia() public returns (NetworkConfig memory){
        return NetworkConfig({entryPoint: 0x5FF137D4b0FDCD49DcA30c7Cf57e578a026d2789});
    }

     function getZkSync() public returns (NetworkConfig memory){
        return NetworkConfig({entryPoint: address(0)});
    }

    function getAnvil() public returns (NetworkConfig memory){
        return NetworkConfig({entryPoint: address(0)});
    }


    function run() public {        
        vm.startBroadcast();
        
        
        vm.stopBroadcast();
    }
    
}