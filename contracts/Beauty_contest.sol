pragma solidity >=0.4.22 <0.8.0;

import 'openzeppelin-solidity/contracts/math/SafeMath.sol';

contract Beauty_contest {
	using SafeMath for uint;

	mapping (address => uint8) betPicks;
	mapping (address => uint) betAmounts;

	string question;
	string choice1;
	string choice2;

	uint8 pot1;
	uint8 pot2;
	uint8 fullPot;
	uint8 winningPot;


	uint8 endtime; 
	uint8 winner = -1;
	
	constructor(string _question, string _choice1, string _choice2, uint8 _contestDurationInDays) public {
		question = _question;
		choice1 = _choice1;
		choice2 = _choice2;
		endtime = now + _contestDurationInDays * 1 days;
	}

	function makeBet(uint8 betPick) payable {
		require(msg.value < mul(5,1000000000000000000), "No bets over 5 eth please!");
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
			msg.sender.transfer(div(mul(fullPot, betAmounts[msg.sender]), winningPot));
			//complicated way of writing (betAmount/winningPot) * fullPot without decimals
		}
		betPicks[msg.sender] = -1; //can no longer withdraw
		betAmounts[msg.sender] = 0; //but just in case
	}

	function contestInfo() public view returns (string key, string _question, string _choice1, string _choice2) {
		//view functions do not modify state, but can read it
		return("The following three strings will indicate the contest question, choice 1, and choice 2 respectively:", 
			question, choice1, choice2);
		// kind of gross and hacky but I dont want to deal with string concatenation
	}

	fallback() external payable {
		revert();
	}
}
