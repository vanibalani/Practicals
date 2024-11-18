// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract Prac6 {
    struct Candidate {
        string name;
        uint voteCount;
    }

    struct Voter {
        bool authorized;
        bool voted;
        uint vote;
    }

    address public owner;
    string public electionName;
    mapping(address => Voter) public voters;
    Candidate[] public candidates;
    uint public totalVotes;
    
    bool public electionEnded;

    modifier ownerOnly() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    modifier electionOngoing() {
        require(!electionEnded, "The election has ended");
        _;
    }

    constructor(string memory _electionName) {
        owner = msg.sender;
        electionName = _electionName;
        electionEnded = false;
    }

    function addCandidate(string memory _name) public ownerOnly electionOngoing {
        candidates.push(Candidate(_name, 0));
    }

    function getNumCandidates() public view returns (uint) {
        return candidates.length;
    }

    function authorize(address _person) public ownerOnly electionOngoing {
        voters[_person].authorized = true;
    }

    function vote(uint voteIndex) public electionOngoing {
        require(!voters[msg.sender].voted, "You have already voted");
        require(voters[msg.sender].authorized, "You are not authorized to vote");

        voters[msg.sender].vote = voteIndex;
        voters[msg.sender].voted = true;

        candidates[voteIndex].voteCount += 1;
        totalVotes += 1;
    }

    function endElection() public ownerOnly {
        electionEnded = true;
        payable(owner).transfer(address(this).balance);
    }

    receive() external payable {}
}