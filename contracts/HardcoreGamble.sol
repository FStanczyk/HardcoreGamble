// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;
import "./SafeMath.sol";
//rules are described in README.txt
contract HardcoreGamble {
    address public owner;
    address public top_stake; //the participant with currently highest bid
    address public winner;
    uint256 public pool;
    uint256 public risk_pool; //the pool at the moment of the highest stake transaction
    mapping(address => uint256) public balances;
    mapping(address => bool) entered;
    enum bid_type{HIGHBALL, LOWBALL}
    bid_type public win_type;
    bool public prize_withdrawed;
    bool public finished;

    constructor() {
        owner = msg.sender;
    }

    modifier restricted() {
        require(msg.sender == owner, "only owner");
        _;
    }
    uint256 number_of_participants;
    address[] participants;

    function enterPool() public payable {
        require(finished == false, "The game has ended...");
        require(
            msg.value >= 0.0001 ether,
            "You have to put at least one Ether..."
        );
        require(!entered[msg.sender], "You have already entered...");
        participants.push(msg.sender);
        entered[msg.sender] = true;
        balances[msg.sender] += msg.value;
        pool += msg.value;

        number_of_participants++;
        if(number_of_participants>=3){
            chooseWinner();
        }else if(balances[msg.sender]>balances[top_stake]){
            top_stake = msg.sender;
        }
    }

    function chooseWinner() private {
        assert(
            number_of_participants >= 3
        );
        uint256 dif;
        if(balances[msg.sender]>balances[top_stake]){
            top_stake = msg.sender;
            if (balances[top_stake] < pool-balances[top_stake]) {
                win_type = bid_type.LOWBALL;                     
                dif = pool-balances[top_stake]; //holds the difference between pool and highest stake
            } else {
                win_type = bid_type.HIGHBALL;  
                dif = pool-balances[top_stake];
            }
            risk_pool = pool;
        }
        if (win_type == bid_type.LOWBALL) {
            if (pool>(risk_pool-balances[top_stake])*2 ) {
                winner = top_stake;
                finished = true;
                }
        }
        else if (win_type == bid_type.HIGHBALL) {
            if (pool-balances[top_stake] > balances[top_stake]) {
                winner = top_stake;
                finished = true;
                }       
        }
    }
//ONLY FOR THE SAKE OF TESTING//
    function getNumberOfParticipants()external view restricted
        returns (uint256)
    {
        return number_of_participants;
    }
    function getWinner() external view restricted returns (address) {
        return winner;
    }

    function getPool() external view restricted returns (uint256) {
        return pool;
    }
//////////////////////////////////
    function withdraw() external payable {
        require(msg.sender == winner, "You are not the winner");
        require(!prize_withdrawed, "You took the prize, game ended.");
        prize_withdrawed=true;
        payable(msg.sender).transfer(pool);
    }
}
