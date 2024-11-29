pragma solidity ^0.8.9;
import {IAccount, PackedUserOperation} from "account-abstraction/interfaces/IAccount.sol";

contract Account is IAccount {
    uint256 private xo = 100;
    address private owner;

    constructor(address _owner) {
        owner = _owner;
    }

    function validateUserOp(
        PackedUserOperation calldata userOp,
        bytes32 userOpHash,
        uint256 missingAccountFunds
    ) external override returns (uint256 validationData) {
        // Note: This is a very basic implementation
        // In a real-world scenario, you'd want to add:
        // 1. Signature verification
        // 2. Nonce checking
        // 3. Ensuring the caller is the entry point
        return 0; // Indicates successful validation
    }

    function increase() public {
        xo++;
    }
}

contract Factory {
    function create(address owner) external returns (address) {
        Account account = new Account(owner);
        return address(account);
    }
}