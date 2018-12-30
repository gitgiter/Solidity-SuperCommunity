pragma solidity ^0.5.0;

contract GameManager {
    
    // one simple gamble game

    uint rand; // a number to guess
    uint constant ticket = 1 ether; // the gamble fee

    uint constant duration = 20 seconds; // duration of the game
    uint endTime;

    // top three participants, who guess most closely
    // if more than two players guess the same num, the first win.
    address payable firstPrize;
    address payable secondPrize;
    address payable thirdPrize;
    // address[] successfullyParticipation; // others

    int[3] topThree; // the top three small distances, default -1 (need to be set to positive)

    constructor() public {
        endTime = now + duration;
        startGame();
    }

    function generateRand() private view returns (uint) {
        uint digits = 16;
        uint modulus = uint(10) ** digits;
        uint num = uint(keccak256(abi.encodePacked(now)));
        return num % modulus;
    }

    function startGame() private {
        
        // set end time
        endTime = endTime + duration;

        // generate a new random number
        rand = generateRand();

        // set the top three to -1
        topThree[0] = -1;
        topThree[1] = -1;
        topThree[2] = -1;

    }

    function secondsRemaining() public view returns (uint) {

        // frequently called by frontend， need to be view to save gas
        if (endTime <= now) {
            return 0;  // can end game
        } else {
            return endTime - now;
        }
    }

    function endGame() public {

        require(now >= endTime, "the game cannot be end now");

        // reward
        rewardWinner();

        // restart game
        startGame();
    }

    function rewardWinner() private {
        
        // three winner get reward by 3:2:1
        uint unit = address(this).balance / 6;
        firstPrize.transfer(unit * 3);
        secondPrize.transfer(unit * 2);
        thirdPrize.transfer(unit * 1);
    }

    function distance(uint _num1, uint _num2) private pure returns(uint) {

        // return the positive distance between _num1 and _num2
        if (_num1 > _num2) {
            return _num1 - _num2;
        }
        else {
            return _num2 - _num1;
        }
    }

    function guess(uint _rand) public payable {
        
        // pay for gamble
        require(msg.value >= ticket, "need to pay for at least 1 ether");

        // return some extra money to sender
        uint changes = msg.value - ticket;
        msg.sender.transfer(changes);

        uint udist = distance(rand, _rand);
        int dist = int(udist);
        
        // compare
        if (topThree[0] == -1 || dist < topThree[0]) {
            topThree[2] = topThree[1];
            topThree[1] = topThree[0];
            topThree[0] = dist;
            thirdPrize = secondPrize;
            secondPrize = firstPrize;
            firstPrize = msg.sender;
        }
        else if (topThree[1] == -1 || dist < topThree[1]) {
            topThree[2] = topThree[1];
            topThree[1] = dist;
            thirdPrize = secondPrize;
            secondPrize = msg.sender;
        }
        else if (topThree[2] == -1 || dist < topThree[2]) {
            topThree[2] = dist;
            thirdPrize = msg.sender;
        }
    }

    function getWinner() internal view returns(address, address, address) {

        // return the winners
        return (firstPrize, secondPrize, thirdPrize);
    }

    function getGameBalance() public view returns(uint) {

        return address(this).balance;
    }

    function getRand() public view returns(uint) {

        // for test
        return rand;
    }
}