pragma solidity ^0.4.24;

import "./Ownable.sol";

contract CharityManager is Ownable {

    // the chairty fund pool is this.balance

    uint perAmount = 1 ether; // the amount to donate must be a multiple of perAmount

    function donateToCharity() public payable {

        require(msg.value >= perAmount);

        // return some extra money to sender
        uint k = msg.value / perAmount;
        if (k > 1) {
            uint changes = msg.value - k * perAmount;
            msg.sender.transfer(changes);
        }

        // sender donate some money to charity
        address(this).transfer(msg.value);
    }

    function donateFromCharity(address _to, uint _amout) public onlyOwner payable {
        // only the manager of this charity fund pool can call this function

        // donate some money to world
        _to.transfer(_amout * perAmount);
    }
}