pragma solidity >=0.4.22 <0.8.0;

import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/SafeMath.sol';

contract Beauty_contest {
	using SafeMath for uint;

	mapping (address => int8) betPicks;
	mapping (address => uint256) betAmounts;

	string question;
	string choice1;
	string choice2;

	uint256 pot1;
	uint256 pot2;
	uint256 fullPot;
	uint256 winningPot;


	uint256 endtime; 
	int8 winner;
	
	constructor(string memory _question, 
		string memory _choice1, 
		string memory _choice2, 
		uint8 _contestDurationInDays) public {
		question = _question;
		choice1 = _choice1;
		choice2 = _choice2;
		endtime = now + _contestDurationInDays * 1 days;
		winner = -1;
	}

	function makeBet(int8 betPick) public payable {
		require(msg.value < SafeMath.mul(5,1000000000000000000), "No bets over 5 eth please!");
		require(now < endtime, "Too late! Contest has ended");
		require(betPick == 1 || betPick == 2, "Pick 1 or 2 to make a bet. Call contestInfo to see what each choice is");
		betAmounts[msg.sender] += msg.value;
		fullPot += msg.value;
		betPicks[msg.sender] = betPick; //no hedging
	}

	function payout() public {
		require(now < endtime, "Contest hasn't ended yet!");
		//declare winner if one hasn't already been declared
		if(winner == -1) {
			if(pot1 > pot2){
				winner = 1;
				winningPot = pot1;
			} else if (pot1 < pot2) {
				winner = 2;
				winningPot = pot2;
			} else {
				winner = 0; //tie
			}
		}
		require(betPicks[msg.sender] == winner || winner == 0);
		if(winner == 0) {
			msg.sender.transfer(betAmounts[msg.sender]); //get back initial bet
		} else {
			msg.sender.transfer(SafeMath.div(SafeMath.mul(fullPot, betAmounts[msg.sender]), winningPot));
			//complicated way of writing (betAmount/winningPot) * fullPot without decimals
		}
		betPicks[msg.sender] = -1; //can no longer withdraw
		betAmounts[msg.sender] = 0; //but just in case
	}

	function contestInfo() public view returns (string memory key, 
		string memory _question, 
		string memory _choice1, 
		string memory _choice2) {
		//view functions do not modify state, but can read it
		return("The following three strings will indicate the contest question, choice 1, and choice 2 respectively:", 
			question, choice1, choice2);
		// kind of gross and hacky but I dont want to deal with string concatenation
	}

	fallback() external payable {
		revert();
	}
}
