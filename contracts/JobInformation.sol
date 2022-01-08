// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

enum JobStatus { Open, PendingCompletion, Completed }

struct JobInformation {
    uint jobId;
    address customer;
    uint bounty;
    string name;
    string description;
    JobStatus status;
}