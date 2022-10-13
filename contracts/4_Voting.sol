// SPDX-License-Identifier: GPL-3.0

/*
Contrat kurucusu bir kurul gibi davranacak ve seçimi başlatıp bitirecek.
Seçimin başlangıç ve bitiş süresi olacak. Öncesinde ve sonrasında oy kullanılmayacak.
Adaylar sözleşme deploy edildikten sonra ve seçim başlamadan girilecek. 
Seçmenler sadece 1 oy kullanacak. Seçmenler kimlik numaralarıyla kaydedilecek.
Adaylar da oy kullanabilecek.
Seçim sona ermeden sonuçlar kurul dahil kimse tarafından görüntülenmeyecek.
Seçim sona erince komite adayların kazandığı toplam oyları açıklayacak. 
*/

pragma solidity ^0.8.13;

contract VotingContract {

    struct Candidate {
        //address candidateAddr;
        //string candidateId;
        string candidateName;
        uint voteCount;
    }

    struct Voter {
        //address voterAddr;
        string voterId;
        bool voted;
        uint vote; 
    }

    address public committee;   // Owner of this contract (observer committee) 

    mapping (address => Voter) public voters;    // Stores a 'Voter' struct for each possible address

    Candidate[] public candidates;    // Array of 'Candidate' struct for all candidates 

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

    uint startTime;
    uint endTime;

    constructor () {
        committee = msg.sender;
        startTime = block.timestamp + 120;  // Voting starts 2 minutes after the contract is uploaded
        endTime = startTime + 600;          // Voting ends 10 minutes after the contract is uploaded.
    }

    //function addCandidate(address _candidateAddr, string calldata _candidateId)
    function addCandidate(string calldata _candidateName)
    OnlyCommittee public {
        
        require(block.timestamp < startTime, "THE ELECTION STARTED, CANDIDATES CANNOT BE ADDED!");

        candidates.push(Candidate({
            //candidateAddr: _candidateAddr,
            //candidateId: _candidateId,
            candidateName: _candidateName,
            voteCount: 0
        }));
    }

    function timeStamp() public view returns(uint){
        return block.timestamp;     // Current time
    }

    function passingTime () Started external view returns (uint _passedTime) {
        require(endTime > block.timestamp, "ELECTION IS OVER!");
        _passedTime = block.timestamp - startTime;   
    }

    function remainingTime () Started external view returns (uint _remainingTime) {
        require(endTime > block.timestamp, "ELECTION IS OVER!");
        _remainingTime = endTime - block.timestamp;
    }


}

