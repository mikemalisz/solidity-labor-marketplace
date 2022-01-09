// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../contracts/LaborMarketplace.sol";

contract LaborMarketplaceHelper {
    // Creates a new marketplace and job on behalf of the caller, such that the customer's address of the job
    // will be this contract and not the caller
    function createWithJob() public payable returns (LaborMarketplace) {
        LaborMarketplace marketplace = new LaborMarketplace();
        marketplace.createJob{value: msg.value}("first job", "description");
        return marketplace;
    }

    // Submits work on behalf of the caller, such that worker's address of the submitted work will be this contract
    // and not the caller's address
    function submitWork(LaborMarketplace marketplace, uint jobId) public {
        marketplace.submitWork(jobId, "job data");
    }

    receive() external payable { }
}