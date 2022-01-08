// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/LaborMarketplace.sol";

contract TestLaborMarketplace {

    uint public initialBalance = 1 ether;

    function testInitialState() public {
        LaborMarketplace sut = new LaborMarketplace();
        Assert.equal(sut.getActiveJobCount(), 0, "Should be no initial active jobs");
        Assert.equal(sut.getCompletedJobCount(), 0, "Should be no initial completed jobs");
    }

    /* Create Job */

    function testCreateJob_itConfiguresTheJobCorrectly() public {
        LaborMarketplace sut = new LaborMarketplace();

        sut.createJob{value: 1000}("first job", "descriptive description");
        
        LaborMarketplace.JobInformation memory result = sut.getJob(1);
        Assert.equal(result.jobId, 1, "expecting job to have id of 1");
        Assert.equal(result.customer, address(this), "expecting customer to be this contract");
        Assert.equal(result.bounty, 1000, "bounty should be 1000 wei");
        Assert.equal(result.name, "first job", "job name should be correct");
        Assert.equal(result.description, "descriptive description", "job description should be correct");
        Assert.equal(uint8(result.status), uint8(LaborMarketplace.JobStatus.Open), "job status should be open");
    }

    function testCreateJob_itAddsItToActiveJobs() public {
        LaborMarketplace sut = new LaborMarketplace();

        sut.createJob{value: 1000}("first job", "descriptive description");
        
        Assert.equal(sut.getActiveJobCount(), 1, "should be one active job");
        Assert.equal(sut.getCompletedJobCount(), 0, "should be no completed jobs yet");
    }
}