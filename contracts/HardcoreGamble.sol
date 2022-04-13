// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;
import "./SafeMath.sol";
//rules are described in README.txt
contract HardcoreGamble {
    address private owner;
    address private top_stake; //the participant with currently highest bid
    address private winner;
    uint256 pool;
    uint256 risk_pool; //the pool at the moment of the highest stake transaction
    mapping(address => uint256) public balances;
    mapping(address => bool) entered;
    bool public highball; //situation when someones bid is higher then half of a pool
    bool public lowball; //situation when someones bid is less then half of a pool
    bool finished;

    constructor() {
        owner = msg.sender;
        pool = 0;
        finished = false;
        balances[top_stake] = 0;
        highball = false;
        lowball = false;
        risk_pool = pool;
    }

    modifier restricted() {
        if (msg.sender == owner) _;
    }
    uint256 number_of_participants;
    address[] participants;

    function enterPool() public payable {
        require(finished == false, "The game has ended...");
        //require(
        //    msg.value >= 0.1 ether,
        //    "You have to put at least one Ether..."
        //);
        require(entered[msg.sender] == false, "You have already entered...");
        participants.push(msg.sender);
        entered[msg.sender] = true;
        balances[msg.sender] += msg.value;
        pool += msg.value;

        number_of_participants = SafeMath.add(1, number_of_participants);
        if(number_of_participants>=3){
            chooseWinner();
        }
    }

    function chooseWinner() private {
        require(
            number_of_participants >= 3,
            "You have to wait for more participants (at least 3)"
        );
        uint256 dif;
        address risk_top_stake; //holds the top bid participant to check if changed 
        //*the participant with the risk of winning
        for (uint256 i = 0; i < number_of_participants; i++) {
            if (balances[participants[i]] > balances[top_stake]) {
                top_stake = participants[i];
                if (top_stake != risk_top_stake) {
                    if (balances[top_stake] < SafeMath.sub(pool,balances[top_stake])) {
                        lowball = true;
                        highball = false;
                        dif = pool-balances[top_stake]; //holds the difference between pool and highest stake
                    } else {
                        highball = true;
                        lowball = false;
                    }
                    risk_top_stake = top_stake;
                    risk_pool = pool;
                }

            }
        }
        if (lowball == true) {
            if (pool>SafeMath.mul((risk_pool-balances[top_stake]),2 )) {winner = top_stake;}
        }
        if (highball == true) {
            if (SafeMath.sub(pool, balances[top_stake]) > balances[top_stake]) {winner = top_stake;}
        }
    }
//ONLY FOR THE SAKE OF TESTING//
    function getNumberOfParticipants()public view restricted
        returns (uint256 a)
    {
        return number_of_participants;
    }
    function getWinner() public view restricted returns (address a) {
        return winner;
    }

    function getPool() public view restricted returns (uint256 a) {
        require(msg.sender == owner);
        return pool;
    }
//////////////////////////////////
    function withdraw() public payable {
        require(msg.sender == winner, "You are not the winner");
        require(finished == false, "You took the prize, game ended.");
        payable(msg.sender).transfer(pool);
        finished = true;
    }
}
