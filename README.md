# DevOps Interview Task 2024

## High-level system overview

Consider we have a backend for an online multiplayer game with N different "game worlds". Each game world is completely isolated from the rest, i.e. any player data in `World1` doesn't relate to any data in `WorldX` and vice-versa. In production, every game world will have its own MySQL database node. All nodes will have an identical `game` database schema. 

Each database node is regularly backed up. In this exercise, let's say we create a database dump at least once day from each node and before every game update.

## Problem Description

Something happened. We have received reports from the community that something is amiss with their scores since today's game update. The game dev team needs to launch an investigation into the state of scores before and after the update. To be able to do this, they need a snapshot of all databases (all game worlds) from before the update to be restored somewhere where they can run some analysis queries on it. All away from the production system. It will be your task to prepare a system running N MySQL database instances, each containing a "point-in-time restore" of a single game world.

## Parameters & Constraints

This is a toy version of a problem we could encounter in reality to make it feasible as an interview exercise. Try to play along. Pretend that you had a problem like this in reality and show us how you would approach such a problem. Here are a few hints how you should approximate reality.

* We fully understand that in practice, managed database offerings from cloud providers can make this pretty easy to solve, but that would be boring. Therefore, and to demonstrate your skills, please run your own MySQL instances, i.e. don't use any database-as-a-service.

* We're providing a sample `.sql.gz` timestamped backups that would restore the `game` database with dummy data. You will find backups from 3 database hosts, 2 dumps each. You can assume that the latest dump from each host is at the point-in-time we need to restore. 

* To narrow the scope down, assume you have only one (sufficiently powerful) linux host that _everything_ would need to run on. For instance, you ideally should be able to run all of it on your local machine.

* You have a degree of freedom in your choice of tool. Use what you know best, show us how you like to work.


## Acceptance criteria

Again, this is a toy problem, designed to let you demonstrate your skills. You decide how much time you want to spend on this. Feel free to hand in partial work, ideally with comments on what is missing, why it is missing, and how you would address the open points. See this as a conversation starter. The most important requirement is that you take the exercise seriously. If you find yourself thinking "I can do better than this", send us the better version.

### Must have

* The entire solution must be runnable on a (ideally: _any_) single linux host. Please provide instructions how to run your solution, and ideally some sort of build/run automation, e. g. a `Makefile` or a `docker-compose.yml`.
* With the solution running, we must be able to connect and run queries on a restored db of any individual world. Please write a brief documentation how to do that, imagine those to be instructions you're handing over to your game dev colleagues.
* The solution is ephemeral and reusable. This means we can easily repeat the process later with different database dumps with a reasonable degree of automation and as few steps as possible. 100% automation from start to finish isn't a must (due to time limitation of this task).

### Should have

* The example has 3 database hosts, 2 dumps each. Think about how to generalise your solution to M backups for N hosts [if this is not what you did from the get go].

### Nice to have [Optional, only if you have time left]

* 100% full automation, start to finsh, e.g. a single cli call would spin up the whole solution from scratch.
* Quality of life improvements, for example a utility giving devs the ability to run a single query on all database nodes with the results aggregated nicely on stdout.
