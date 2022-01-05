// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IdManager.sol";

struct JobInformation {
    uint jobId;
    address customer;
    uint bounty;
    string name;
    string description;
}

struct PendingCompletedWork {
    JobInformation job;
    address worker;
    string work;
}

contract LaborMarketplace {
    IdManager jobIdManager = new IdManager();

    uint[] public activeJobIds;
    mapping(uint => JobInformation) availableJobs;
    mapping(uint => PendingCompletedWork) pendingJobs;

    function createJob(string memory name, string memory description) public payable {
        uint jobId = jobIdManager.createId();
        JobInformation memory newJob = JobInformation(
            {
                jobId: jobId,
                customer: msg.sender,
                bounty: msg.value,
                name: name,
                description: description
            }
        );

        availableJobs[jobId] = newJob;
        activeJobIds.push(jobId);
    }

    function submitWork(uint jobId, string memory work) public {
        JobInformation memory job = getAvailableJob(jobId);

        PendingCompletedWork memory pendingWork = PendingCompletedWork({
            job: job,
            worker: msg.sender,
            work: work
        });

        pendingJobs[jobId] = pendingWork;
        delete availableJobs[jobId];
    }

    function completeJob(uint jobId, bool acceptWork) public {
        PendingCompletedWork memory pendingJob = getPendingJob(jobId);
        require(pendingJob.job.customer == msg.sender, "Must be job's original customer");


        // close out pending job and remove it from active job id array
        delete pendingJobs[jobId];
        for (uint i; i < activeJobIds.length; i++) {
            if (jobId == activeJobIds[i]) {
                activeJobIds[i] = activeJobIds[activeJobIds.length - 1];
                activeJobIds.pop();
                break;
            }
        }

        // submit payment if work was accepted by the customer
        if (acceptWork) {
            payable(pendingJob.worker).transfer(pendingJob.job.bounty);
        }
    }

    function getAvailableJob(uint jobId) public view returns (JobInformation memory) {
        require(isAvailableJobId(jobId), "Invalid job id");
        return availableJobs[jobId];
    }

    function getPendingJob(uint jobId) public view returns (PendingCompletedWork memory) {
        require(isPendingJobId(jobId), "Invalid job id");
        return pendingJobs[jobId];
    }

    function isAvailableJobId(uint jobId) private view returns (bool) {
        return availableJobs[jobId].jobId != 0;
    }

    function isPendingJobId(uint jobId) private view returns (bool) {
        return pendingJobs[jobId].job.jobId != 0;
    }

    function getActiveJobCount() public view returns (uint) {
        return activeJobIds.length;
    }
}