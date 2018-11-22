pragma solidity ^0.4.24;

import "./Ownable.sol";

contract CharityManager is Ownable {

    // the chairty fund pool is this.balance

    uint perAmount = 1 ether; // the amount to donate must be a multiple of perAmount

    function donateToCharity() public payable {

        // pay for donation
        require(msg.value >= perAmount, "should pay more than 1 ether");

        // return some extra money to sender
        uint k = msg.value / perAmount;
        uint changes = msg.value - k * perAmount;
        msg.sender.transfer(changes);
    }

    function donateFromCharity(address _to, uint _amout) public onlyOwner {
        // only the manager of this charity fund pool can call this function

        // donate some money to world
        _to.transfer(_amout * perAmount);
    }
}