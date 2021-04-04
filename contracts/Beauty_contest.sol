pragma solidity >=0.4.22 <0.8.0;

import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/SafeMath.sol';

contract Beauty_contest {
	using SafeMath for uint;

	event winnerDeclared(string question, string choice0, string choice1, int8 winner);
	event betPlaced(address);

	mapping (address => int8) betPicks;
	mapping (address => uint256) betAmounts;

	string question;
	string[2] choices;

	uint8[2] choicePots;

	uint256 fullPot;
	uint256 winningPot;

	uint256 endtime; 
	int8 winner;
	
	constructor(string memory _question, 
		string memory _choice0, 
		string memory _choice1, 
		uint8 _contestDurationInDays) public {
		question = _question;
		choices[0] = _choice0;
		choices[1] = _choice1;
		endtime = now + _contestDurationInDays * 1 days;
		winner = -1;
	}

	function makeBet(uint8 betPick) public payable {
		require(msg.value < SafeMath.mul(5,1000000000000000000), "No bets over 5 eth please!"); 
		require(now < endtime, "Too late! Contest has ended");
		require(betPick == 0 || betPick == 1, "Pick 0 or 1 to make a bet. Call contestInfo to see what each choice is");
		betAmounts[msg.sender] += msg.value;
		choicePots[betPick] += msg.value;
		fullPot += msg.value;
		betPicks[msg.sender] = betPick; //no hedging
		emit betPlaced(msg.sender);
	}

	function payout() public {
		require(now > endtime, "Contest hasn't ended yet!");
		//declare winner if one hasn't already been declared
		if(winner == -1) {
			if(pot0 > pot1){
				winner = 0;
				winningPot = choicePots[winner];
			} else if (pot0 < pot1) {
				winner = 1;
				winningPot = choicePots[winner];
			} else {
				winner = 2; //tie
			}
			winningPot = 
			emit winnerDeclared(question, choice0, choice1, choices[winner]);
		}
		if(winner == 2) {
			msg.sender.transfer(betAmounts[msg.sender]); //get back initial bet

		} else if(winner == betPicks[msg.sender]){
			msg.sender.transfer(SafeMath.div(SafeMath.mul(fullPot, betAmounts[msg.sender]), winningPot));
			//complicated way of writing (betAmount/winningPot) * fullPot without decimals
		}
		betAmounts[msg.sender] = 0; //cannot withdraw again
	}

	function contestInfo() public view returns (string memory key, 
		string memory _question, 
		string memory _choice0, 
		string memory _choice1) {
		//view functions do not modify state, but can read it
		return("The following three strings will indicate the contest question, choice 1, and choice 2 respectively:", 
			question, choices[0], choice2[1]);
	}

	fallback() external payable {
		revert();
	}
}
