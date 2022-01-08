# 🦺 Labor marketplace implemented in Solidity

## Goal

The primary goal of this project was to learn more about Solidity and the Ethereum ecosystem. This app is simplistic by design and not intended to be used in a production environment. Just for learning 🤓

## Idea

The idea of this project is to help facilitate transactions for labor between two independent parties, a customer and worker. The marketplace is built around jobs, which are created by customers and completed by workers.

## The lifecycle of a job follows these steps:

1. Customers can create a new job by sending a transaction to the `createJob` function.
   Creating a job requires a `name` for the job, `description` of the work to be done, as well as the `value` of wei the customer is willing to pay to have the work completed.

2. Workers can view the newly created job (and all other available jobs) via the `getAvailableJob` function

3. Once a worker has completed a job, they can submit the work for that job via `submitWork`.
   This requires the `jobId` for the job the worker is completing, as well as `work` for the completed job. `work` is a string type with the intention of most likely being a placeholder to an external link (like GitHub repo or Google Doc).

   This action removes the job from the `availableJob` state and moves it over to a `pendingJob` state. This means that no more workers can submit work for this job until the customer either accepts or denies the work submitted by the worker.

4. The customer must now invoke the `completeJob` function.
   This function requires a `jobId` parameter indicating the job to complete, as well as a bool `acceptWork` which indicates if they would like to accept the work submitted by the worker.