// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/LaborMarketplace.sol";

contract TestLaborMarketplace {
    function testInitialState() public {
        LaborMarketplace sut = new LaborMarketplace();
        Assert.equal(sut.getActiveJobCount(), 0, "Should be no initial active jobs");
        Assert.equal(sut.getCompletedJobCount(), 0, "Should be no initial active jobs");
    }
}