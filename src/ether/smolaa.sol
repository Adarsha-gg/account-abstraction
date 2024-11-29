//SPDX-License-Identifier:MIT

pragma solidity 0.8.28;

import {IAccount} from "account-abstraction/interfaces/IAccount.sol";
import {PackedUserOperation} from "account-abstraction/interfaces/PackedUserOperation.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {MessageHashUtils} from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";
import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import {EntryPoint} from "account-abstraction/core/EntryPoint.sol";
import {IEntryPoint} from "account-abstraction/interfaces/IEntryPoint.sol";

contract Ethereum_Abstract is IAccount, Ownable{
    error CallNotFromEntryPoint();


    IEntryPoint private immutable i_entrypoint;

    constructor(address entryPoint) Ownable(msg.sender){
        i_entrypoint = IEntryPoint(entryPoint);
    }

    modifier requireFromEntryPoint(){
        if(msg.sender == address(i_entrypoint)){
            revert CallNotFromEntryPoint();
        }
        _;
    }
    
    function validateUserOp(PackedUserOperation calldata userOp,  bytes32 userOpHash, uint256 missingAccountFunds)
    external requireFromEntryPoint returns (uint256 validationData) 
    {
        _validateSig(userOp, userOpHash);   
    }

    function _validateSig(PackedUserOperation calldata userOp,  bytes32 userOpHash) internal view returns(uint256 validationData)
    {
        bytes32 ethSignedMessageHash = MessageHashUtils.toEthSignedMessageHash(userOpHash);
        address signer =ECDSA.recover(ethSignedMessageHash, userOp.signature);
        if (signer != owner()){
            return 1;
        }
        return 0;
    }

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