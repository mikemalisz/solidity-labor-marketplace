// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../contracts/LaborMarketplace.sol";

contract LaborMarketplaceHelper {
    function createWithJob() public payable returns (LaborMarketplace) {
        LaborMarketplace marketplace = new LaborMarketplace();
        marketplace.createJob{value: msg.value}("first job", "description");
        return marketplace;
    }
}