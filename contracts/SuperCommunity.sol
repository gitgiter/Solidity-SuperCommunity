pragma solidity ^0.5.0;

import "./UserManager.sol";
import "./CommentManager.sol";
import "./MailManager.sol";
import "./CharityManager.sol";
import "./GameManager.sol";

contract SuperCommunity is UserManager, CommentManager, MailManager, CharityManager, GameManager {
    
    function sendComment(string memory _comment) public registered(msg.sender) {

        // the sender should have registered
        User memory user = addrToUser[msg.sender];
        addComment(user.name, _comment, user.head_img);
    }

    function rewardComment(uint _id) public payable existName(getNameByCommentId(_id)) returns(address) {

        // the name should exist
        string memory name = getNameByCommentId(_id);
        address payable to = nameToAddr[name];
        address sender = rewardByAddr(to, _id);
        return sender;
    }

    function sendMail(string memory _to, string memory _title, string memory _text) public
        registered(msg.sender)
        existName(_to) {

        // the sender should have registered and so do the receiver
        User memory user = addrToUser[msg.sender];
        addMail(user.name, _to, _title, _text);
    }

    function getWinnerName() public view returns(string memory, string memory, string memory) {

        address addr1;
        address addr2;
        address addr3;
        (addr1, addr2, addr3) = getWinner();
        return (getNameByAddr(addr1), getNameByAddr(addr2), getNameByAddr(addr3));
    }
}