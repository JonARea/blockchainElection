pragma solidity ^0.4.17;

contract Election {

  struct Candidate {
    string name;
    uint votes;
  }

  struct Voter {
    bool authorized;
    bool voted;
    uint voteIndex;
  }

  address public owner;
  mapping (address => Voter) public voters;
  string public name;
  Candidate[] public candidates;
  uint public electionEnd;

  event TallyVotes(string name, uint votes);

  function Election(string _name, uint durationMinutes, string candidate1, string candidate2) {
    name = _name;
    owner = msg.sender;
    electionEnd = now + (durationMinutes * 1000 * 60) + 1;
    candidates.push(Candidate(candidate1, 0));
    candidates.push(Candidate(candidate2, 0));
  }

  function authorize(address voter) {
    require(msg.sender == owner);
    require(!voters[voter].voted);
    voters[voter].authorized = true;
  }

  function vote(uint candidateIndex) {
    require(!voters[msg.sender].voted);
    require(voters[msg.sender].authorized);
    require(now < electionEnd);
    candidates[candidateIndex].votes++;
    voters[msg.sender].voted = true;
    voters[msg.sender].voteIndex = candidateIndex;
  }
  function end() {
    require(msg.sender == owner);
    require(now > electionEnd);

    for (uint i = 0; i < candidates.length; i++) {
      TallyVotes(candidates[i].name, candidates[i].votes);
    }
  }
}
