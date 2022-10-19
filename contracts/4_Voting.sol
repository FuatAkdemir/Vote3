// SPDX-License-Identifier: GPL-3.0

/* TR
Contrat kurucusu bir kurul gibi davranacak.
Seçimin başlangıç ve bitiş süresi olacak. Öncesinde ve sonrasında oy kullanılmayacak.
Başlangıç süresi deploy'dan 1 dk sonradır ve bitiş başlangıçtan 1 dk sonradır.
Adaylar sözleşme deploy edildikten sonra ve seçim başlamadan girilecek. 
Seçmenler sadece 1 oy kullanacak. Seçmenler kimlik numaralarıyla kaydedilecek.
Adaylar da oy kullanabilecek.
Seçim sona ermeden sonuçlar kurul dahil kimse tarafından görüntülenmeyecek.
Seçim sona erince kurul adayların kazandığı toplam oyları açıklayacak. 
*/

/* EN
The contract founder will act as a committee.
The voting will have a start and end time. There will be no voting before or after.
Start time is 1 minute after deploy and end time is 1 minute after start.
Candidates will be entered after the contract is deployed and before the election begins.
Voters will only cast 1 vote. Voters will be registered with their ID numbers.
Candidates can also vote.
The results will not be viewed by anyone, including the committee, before the election is over.
After the election is over, the committee will announce the total votes won by the candidates.
*/

pragma solidity ^0.8.13;

contract VotingContract {

    struct Candidate {
        string candidateName;
        uint voteCount;
    }

    struct Voter {
        uint voterIdNumber;
        bool voted;
        string votedTo;
    }

    modifier OnlyCommittee{
        require(committee == msg.sender, "ONLY COMMITTEE CAN MAKE THIS!");
        _;
    }

    modifier Started{
        require(startTime < block.timestamp, "THE ELECTION IS NOT STARTED YET!");
        _;
    }

    modifier Ended{
        require(endTime < block.timestamp, "THE ELECTION IS NOT ENDED YET!");
        _;
    }

    uint startTime;         // Start time of voting
    uint endTime;           // End time of voting
    address committee;      // Owner of this contract (observer committee) 

    mapping (uint => Voter) public voters;    // Stores a 'Voter' struct for each possible address
    mapping (string => Candidate) public candidateMap;
    mapping (string => bool) public inserted; 
    Candidate[] candidates;    // Array of 'Candidate' struct for all candidates

    constructor () {
        committee = msg.sender;
        startTime = block.timestamp + 60;      // Voting starts 1 minute after the contract is uploaded
        endTime = startTime + 60;              // Voting ends 1 minute after the contract is uploaded.
    }

    function addCandidate(string calldata _candidateName) OnlyCommittee public {
        
        require(block.timestamp < startTime, "THE ELECTION STARTED, CANDIDATES CANNOT BE ADDED!");
        require(!inserted[_candidateName], "THE CANDIDATE IS ALREADY ADDED!");
        
        candidateMap[_candidateName] = Candidate({
            candidateName: _candidateName,
            voteCount: 0
        });
        
        candidates.push(Candidate({
            candidateName: _candidateName,
            voteCount: 0
        }));

        inserted[_candidateName] = true;

    }

    function vote(uint _from, string memory _to) Started public {
        require(endTime > block.timestamp, "ELECTION ENDED!");      
        Voter storage sender = voters[_from];
        require(!sender.voted, "YOU ALREADY VOTED!");
        require(inserted[_to], "CANDIDATE NOT FOUND!");          
        
        sender.voterIdNumber = _from;
        sender.voted = true;
        sender.votedTo = _to;

        candidateMap[_to].voteCount++; 
        for(uint i; i<candidates.length; i++){
            //if(keccak256(abi.encodePacked((candidates[i].candidateName))) == keccak256(abi.encodePacked((_to)))){
            if(keccak256(bytes((candidates[i].candidateName))) == keccak256(bytes((_to)))){
                candidates[i].voteCount++;
            }
        }
    }

    function results () OnlyCommittee Ended public view returns(Candidate[] memory _results) {
        _results = candidates;
    }
    
    function winner() public view returns (uint _winner) {

        uint winningVoteCount;
        for (uint i=0; i<candidates.length; i++) 
        {
            if (candidates[i].voteCount > winningVoteCount) {
                winningVoteCount = candidates[i].voteCount;
                _winner = i;
            }
        }
    }

    function winnerName() public view returns (string memory _winner) {
        _winner = candidates[winner()].candidateName;
    }

    function passingTime () Started external  view returns (uint _passedTime) {
        require(endTime > block.timestamp, "ELECTION IS OVER!");
        _passedTime = block.timestamp - startTime;   
    }

    function remainingTime () Started external view returns (uint _remainingTime) {
        require(endTime > block.timestamp, "ELECTION IS OVER!");
        _remainingTime = endTime - block.timestamp;
    }

}

