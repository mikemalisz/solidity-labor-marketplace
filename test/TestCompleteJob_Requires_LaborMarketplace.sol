// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/LaborMarketplace.sol";

import "./LaborMarketplaceHelper.sol";

contract TestCompleteJob_Requires_LaborMarketplace {

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
    
    /* Require */

    function testCompleteJob_jobMustExist() public {
        bytes memory encodedFunctionCall = abi.encodeWithSignature("completeJob(uint256,bool)", 2, true);
        (bool success, ) = address(sut).call(encodedFunctionCall);
        Assert.isFalse(success, "Shouldn't complete non-existant job");
    }

    function testCompleteJob_jobStatusMustBePendingCompletion() public {
        // create a job with Open status
        sut.createJob{value: 100}("hello", "world");

        bytes memory encodedFunctionCall = abi.encodeWithSignature("completeJob(uint256,bool)", 2, true);
        (bool success, ) = address(sut).call(encodedFunctionCall);
        Assert.isFalse(success, "Job must have a status of PendingCompletion");
    }

    function testCompleteJob_mustBeOriginalCustomerForJob() public {
        // create job where helper is the job's original customer
        sut = helper.createWithJob();
        sut.submitWork(1, "data");

        bytes memory encodedFunctionCall = abi.encodeWithSignature("completeJob(uint256,bool)", 1, true);
        (bool success, ) = address(sut).call(encodedFunctionCall);
        Assert.isFalse(success, "Must be original customer for job");
    }
}