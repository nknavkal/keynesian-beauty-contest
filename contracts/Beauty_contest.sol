pragma solidity >=0.4.22 <0.8.0;

contract Beauty_contest {

	struct bet {
		uint amount;
		uint8 choice;
	}


	mapping (address => uint) betValues;
	mapping (address => uint8) betChoices;

	string choice1;
	string choice2;
	string choice3;
	string choice4;
	string choice5;

	constructor(string _choice1, string _choice2, string _choice3, string _choice4, string _choice5) public {
		choice1 = _choice1;
		choice2 = _choice2;
		choice3 = _choice3;
		choice4 = _choice4;
		choice5 = _choice5;
	}

	function makeBet(uint8 choice) payable {
		require(msg.value < 5 * 1000000000000000000, "No bets over 5 eth please!");
	}

	function getMyBet() returns (string choice, unit value){
		return(betValues[msg.sender], betChoices[msg.sender])
	}

	function payout() {

	}
}