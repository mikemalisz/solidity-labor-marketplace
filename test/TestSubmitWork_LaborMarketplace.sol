// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/LaborMarketplace.sol";

import "./LaborMarketplaceHelper.sol";

contract TestSubmitWork_LaborMarketplace {

    uint public initialBalance = 1 ether;

    LaborMarketplace sut;
    LaborMarketplaceHelper helper;

    function beforeEach() public {
        helper = new LaborMarketplaceHelper();
        sut = helper.createWithJob{value: 100}();
    }
    
    function testSubmitWork_itUpdatesTheJobStateToPendingCompletion() public {
        sut.submitWork(1, "job data");

        LaborMarketplace.JobInformation memory jobResult = sut.getJob(1);
        Assert.equal(uint8(jobResult.status), uint8(LaborMarketplace.JobStatus.PendingCompletion), "job status should be updated to pending completion");
    }

    function testSubmitWork_itSubmitsWorkCorrectly() public {
        sut.submitWork(1, "job data");

        LaborMarketplace.CompletedWork memory workResult = sut.getWork(1);
        Assert.equal(workResult.jobId, 1, "expecting work to have same id as job");
        Assert.equal(workResult.worker, address(this), "expecting worker address to be this contract");
        Assert.equal(workResult.data, "job data", "expecting stored data to match submitted data");
    }
}