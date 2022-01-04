// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract IdManager {
    uint public count = 1;

    function createId() public returns (uint) {
        uint current = count;
        count++;
        return current;
    }
}