//SPDX-License-Identifier:MIT

pragma solidity 0.8.28;

import {IAccount} from "account-abstraction/interfaces/IAccount.sol";
import {PackedUserOperation} from "account-abstraction/interfaces/PackedUserOperation.sol";
import {Ownable} from "openzeppelin-contracts/contracts/access/Ownable.sol";
import {MessageHashUtils} from "openzeppelin-contracts/contracts/utils/cryptography/MessageHashUtils.sol";
import {ECDSA} from "openzeppelin-contracts//contracts/utils/cryptography/ECDSA.sol";
import {EntryPoint} from "account-abstraction/core/EntryPoint.sol";
import {IEntryPoint} from "account-abstraction/interfaces/IEntryPoint.sol";

contract EthAbstract is IAccount, Ownable
{
    error CallNotFromEntryPoint();
    error CallNotFromOwnerOrEntryPoint();
    error CallFailed(bytes);

    IEntryPoint private immutable i_entrypoint;

    constructor(address entryPoint) Ownable(msg.sender){
        i_entrypoint = IEntryPoint(entryPoint); //starting point for all contracts
    }

    modifier requireFromEntryPoint(){
        if(msg.sender == address(i_entrypoint)){
            revert CallNotFromEntryPoint();
        }
        _;
    }
    
    modifier eitherEntryPointOrOwner(){
        if(msg.sender != address(i_entrypoint) && msg.sender != owner()){
            revert CallNotFromOwnerOrEntryPoint();
        }
        _;
    }

    
    function validateUserOp(PackedUserOperation calldata userOp,  bytes32 userOpHash, uint256 missingGas)
    external requireFromEntryPoint returns (uint256 validationData)
    { // takes op, ophash and gas to return if unused, validates everything and returns
        _validateSig(userOp, userOpHash);   
        payPrefund(missingGas);
    }

    function _validateSig(PackedUserOperation calldata userOp,  bytes32 userOpHash) internal view returns(uint256 validationData)
    { // takes data and checks sig
        bytes32 ethSignedMessageHash = MessageHashUtils.toEthSignedMessageHash(userOpHash); // needed to hash to check sig by breaking it down
        address signer =ECDSA.recover(ethSignedMessageHash, userOp.signature); //checking signer by breaking down the sig
        if (signer != owner()){
            return 1;
        }
        return 0;
    }

    function execute(address destination, uint256 value, bytes calldata functionData)
     external eitherEntryPointOrOwner {
        //execute the main function using either the owner or the entrypoint
        (bool success, bytes memory data) = destination.call{value: value}(functionData);
        if (!success) {
            revert CallFailed(data);
        }
     } 

    function receiveEth() external payable{
        //just recieve eth thats all lol
    }

    function payPrefund(uint256 missingGas) internal {
        // just return back the gas. If it says msg sender, doesnt it go to the entry point? rather than account?
        if(missingGas > 0){
            (bool success,) = payable(msg.sender).call{value: missingGas, gas:type(uint256).max}("");
            require(success, "Failed to return gas"); 
        }
    }


    // FOR REFERENCE
    // PackedUserOperation {
    // address sender;   //our acc
    // uint256 nonce;    // one time use number?
    // bytes initCode;   // ignor
    // bytes callData;   // the main stuff like ur logic or smth
    // bytes32 accountGasLimits;       //gas likmit
    // uint256 preVerificationGas;     // gas
    // bytes32 gasFees;
    // bytes paymasterAndData;        //who pays the thing
    // bytes signature;               // 
// }

    function getEntryPoint() public view returns(address){
        return address(i_entrypoint);
    }

}