// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IdManager.sol";

contract LaborMarketplace {

    /* Properties */

    IdManager jobIdManager = new IdManager();

    uint[] public activeJobIds;
    uint[] public completedJobIds;

    mapping(uint => JobInformation) jobs;
    mapping(uint => CompletedWork) submittedWork;

    /* Public API */

    function createJob(string memory name, string memory description) public payable {
        uint jobId = jobIdManager.createId();
        JobInformation memory newJob = JobInformation(
            {
                jobId: jobId,
                customer: msg.sender,
                bounty: msg.value,
                name: name,
                description: description,
                status: JobStatus.Open
            }
        );

        jobs[jobId] = newJob;
        activeJobIds.push(jobId);
    }

    function submitWork(uint jobId, string memory data) public jobExists(jobId) {
        JobInformation storage job = jobs[jobId];
        require(job.status == JobStatus.Open, "Job is not currently accepting work");

        CompletedWork memory work = CompletedWork({
            jobId: jobId,
            worker: msg.sender,
            data: data
        });

        submittedWork[jobId] = work;
        job.status = JobStatus.PendingCompletion;
    }

    function completeJob(uint jobId, bool acceptWork) public jobExists(jobId) {
        JobInformation storage job = jobs[jobId];
        require(job.status == JobStatus.PendingCompletion, "Job must be pending completion");
        require(job.customer == msg.sender, "Caller must be job's original customer");
        
        CompletedWork memory work = submittedWork[jobId];
        require(work.jobId != 0, "Invalid completed work");

        if (acceptWork) {
            // pay the worker and clean up job state
            payable(work.worker).transfer(job.bounty);

            for (uint i; i < activeJobIds.length; i++) {
                // delete job id from active job ids
                if (jobId == activeJobIds[i]) {
                    activeJobIds[i] = activeJobIds[activeJobIds.length - 1];
                    activeJobIds.pop();
                    break;
                }
            }
            job.status = JobStatus.Completed;
            completedJobIds.push(jobId);
        } else {
            // delete submitted work, update job state back to open
            delete submittedWork[jobId];
            job.status = JobStatus.Open;
        }
    }

    function getJob(uint jobId) public view jobExists(jobId) returns (JobInformation memory) {
        return jobs[jobId];
    }

    function getWork(uint jobId) public view jobExists(jobId) returns (CompletedWork memory) {
        return submittedWork[jobId];
    }

    function getActiveJobCount() public view returns (uint) {
        return activeJobIds.length;
    }

    function getCompletedJobCount() public view returns (uint) {
        return completedJobIds.length;
    }

    /* Utility */

    modifier jobExists(uint id) {
        // Job id should never be zero
        require(jobs[id].jobId != 0, "Invalid job id");
        _;
    }

    /* Custom types */

    enum JobStatus { Open, PendingCompletion, Completed }

    struct JobInformation {
        uint jobId;
        address customer;
        uint bounty;
        string name;
        string description;
        JobStatus status;
    }

    struct CompletedWork {
        uint jobId;
        address worker;
        string data;
    }
}