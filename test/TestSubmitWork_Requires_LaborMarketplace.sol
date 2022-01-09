// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/LaborMarketplace.sol";

import "./LaborMarketplaceHelper.sol";

contract TestSubmitWork_Requires_LaborMarketplace {

    uint public initialBalance = 1 ether;

    LaborMarketplace sut;
    LaborMarketplaceHelper helper;

    function beforeEach() public {
        helper = new LaborMarketplaceHelper();
        sut = helper.createWithJob{value: 100}();
    }

    function testSubmitWork_jobMustExist() public {
        bytes memory encodedFunctionCall = abi.encodeWithSignature("submitWork(uint256,string)", 2, "more data");
        (bool success, ) = address(sut).call(encodedFunctionCall);
        Assert.isFalse(success, "Can't submit work for non-existant job");
    }
    
    function testSubmitWork_canSubmitWorkOnlyOnce() public {
        sut.submitWork(1, "data");

        bytes memory encodedFunctionCall = abi.encodeWithSignature("submitWork(uint256,string)", 1, "more data");
        (bool success, ) = address(sut).call(encodedFunctionCall);
        Assert.isFalse(success, "Submit work only once for a job");
    }
}