// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/LaborMarketplace.sol";

import "./LaborMarketplaceHelper.sol";

contract TestCompleteJob_LaborMarketplace {

    uint public initialBalance = 1 ether;

    LaborMarketplace sut;
    LaborMarketplaceHelper helper;

    function beforeEach() public {
        sut = new LaborMarketplace();
        sut.createJob{value: 100}("test job", "test description");

        helper = new LaborMarketplaceHelper();
        payable(address(helper)).transfer(10000);
        helper.submitWork(sut, 1);
    }
    
    /* acceptWork = true */

    function testCompleteJob_acceptWorkIsTrue_itTransfersTheBountyAmountToTheWorker() public {
        uint previousBalance = address(helper).balance;
        sut.completeJob(1, true);
        uint delta = address(helper).balance - previousBalance;

        Assert.equal(delta, 100, "Helper should have received 100 wei on job completion");
    }

    function testCompleteJob_acceptWorkIsTrue_itUpdatesTheJobIdsState() public {
        sut.completeJob(1, true);
        Assert.equal(sut.getActiveJobCount(), 0, "Job should no longer be considered active");
        Assert.equal(sut.getCompletedJobCount(), 1, "Should be one completed job now");
        Assert.equal(sut.completedJobIds(0), 1, "Completed job should have an id of 1");
    }

    function testCompleteJob_acceptWorkIsTrue_itUpdatesTheJobStatusToCompleted() public {
        sut.completeJob(1, true);
        LaborMarketplace.JobInformation memory result = sut.getJob(1);
        Assert.equal(uint8(result.status), uint8(LaborMarketplace.JobStatus.Completed), "Job should no longer be considered active");
    }

    /* acceptWork = false */

    function testCompleteJob_acceptWorkIsFalse_itDeletesTheSubmittedWork() public {
        sut.completeJob(1, false);
        LaborMarketplace.CompletedWork memory result = sut.getWork(1);
        Assert.equal(result.jobId, 0, "Completed work should have been deleted");
    }

    function testCompleteJob_acceptWorkIsFalse_itSetsTheJobStatusToOpen() public {
        sut.completeJob(1, false);
        LaborMarketplace.JobInformation memory result = sut.getJob(1);
        Assert.equal(uint8(result.status), uint8(LaborMarketplace.JobStatus.Open), "Job should be set back to Open status");
    }
}