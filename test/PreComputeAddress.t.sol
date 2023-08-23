//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../src/PreComputeAddress.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";

contract PreComputeAddressTest is Test {
    address _alice;

    function setUp() public {
        _alice = makeAddr("alice");
    }

    function testComputeAddress() public {
        PreComputeAddress preComputeAddress = new PreComputeAddress();
        bytes memory bytecode = preComputeAddress.getByteCode(0);
        address computedAddress = preComputeAddress.computeAddress(bytecode, 0);
        address deployedAddresss = preComputeAddress.deploy(bytecode, 0);
        assertEq(computedAddress, deployedAddresss);
    }
}
