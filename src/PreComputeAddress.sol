//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./Counter.sol";

contract PreComputeAddress {
    function getByteCode(uint256 number) public pure returns (bytes memory) {
        bytes memory bytecode = type(Counter).creationCode;
        return abi.encodePacked(bytecode, abi.encode(number));
    }

    //create
    // new_address=hash(senderAddress, nonce)
    //create2
    //new_address = hash(0xFF, sender, salt, bytecode)

    function computeAddress(
        bytes memory _byteCode,
        uint256 _salt
    ) public view returns (address) {
        bytes32 hash = keccak256(
            abi.encodePacked(
                bytes1(0xff), // a constant that prevents collisions with CREATE
                address(this), // owner address
                _salt, // an arbitrary value
                keccak256(_byteCode)
            )
        );
        return address(uint160(uint256(hash)));
    }

    function deploy(
        bytes memory _byteCode,
        uint256 _salt
    ) public payable returns (address) {
        address depAddr;

        assembly {
            depAddr := create2(
                callvalue(), // amount of Ether to be sent to the contract being deployed.
                add(_byteCode, 0x20), // This is the location in memory where the contract bytecode starts
                mload(_byteCode), //loads the bytecode at the memory location specified previously.
                _salt // random 32-byte value used to generate a deterministic address for the deployed contract
            )

            if iszero(extcodesize(depAddr)) {
                revert(0, 0)
            }
        }
        return depAddr;
    }
}
