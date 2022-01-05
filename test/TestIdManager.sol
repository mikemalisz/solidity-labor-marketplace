// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/IdManager.sol";

contract TestIdManager {
    function testInitialState() public {
        IdManager sut = new IdManager();
        Assert.equal(sut.count(), 1, "count should initially be 1");
    }

    function testCreateId_returnsInitialId() public {
        IdManager sut = new IdManager();
        uint result = sut.createId();
        Assert.equal(result, 1, "result should initially be 1");
    }

    function testCreateId_incrementsCount() public {
        IdManager sut = new IdManager();
        sut.createId();
        Assert.equal(sut.count(), 2, "count should be 2");
    }

    function testCreateId_returnsCorrectId_afterFiveIterations() public {
        IdManager sut = new IdManager();
        for (uint i; i < 4; i++) {
            sut.createId();
        }

        // createId() for the 5th time
        uint result = sut.createId();
        Assert.equal(result, 5, "result should be 5 after 5 iterations");
    }

    function testCreateId_incrementsCount_afterFiveIterations() public {
        IdManager sut = new IdManager();
        for (uint i; i < 5; i++) {
            sut.createId();
        }
        Assert.equal(sut.count(), 6, "count should be 6 after 5 iterations");
    }
}