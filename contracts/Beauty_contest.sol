pragma solidity >=0.4.22 <0.8.0;

import 'openzeppelin-solidity/contracts/math/SafeMath.sol';

contract Beauty_contest {
	using SafeMath for uint;

	struct bet {
		uint amount;
		uint8 choice;
	}

	struct choice {
		mapping (address => uint) betAmounts;
		uint pot;
	}

	// choice choices[5];

	// mapping (address => bet) bets;
	mapping (address => bet) bets;

	string choice0;
	string choice1;
	string choice2;
	string choice3;
	string choice4;

	constructor(string _question, string _choice0, string _choice1, string _choice2, 
		string _choice3, string _choice4) public {
		question = _question;
		choice0 = _choice0;
		choice1 = _choice1;
		choice2 = _choice2;
		choice3 = _choice3;
		choice4 = _choice4;
	}

	function makeBet(uint8 choice) payable {
		require(msg.value < mul(5,1000000000000000000), "No bets over 5 eth please!");
		choices[choice].betAmounts[msg.sender] = msg.value;
		choices[choice].pot = add(choices[choice].pot, msg.value);
	}

//view
	function getMyBet() returns (string choice, unit value){
		return(bets[msg.sender].amount, bets[msg.sender].choice);
	}

	function payout() {

	}
}
