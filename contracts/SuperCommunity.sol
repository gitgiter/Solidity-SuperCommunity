pragma solidity ^0.4.24;

import "./UserManager.sol";
import "./CommentManager.sol";
import "./MailManager.sol";
import "./CharityManager.sol";

contract SuperCommunity is UserManager, CommentManager, MailManager, CharityManager {
    
    function sendComment(string memory _comment) public registered(msg.sender) {

        // the sender should have registered
        User memory user = addrToUser[msg.sender];
        addComment(user.name, _comment, user.head_img);
    }

    function rewardComment(uint _id) public payable existName(getNameByCommentId(_id)) returns(address) {

        // the name should exist
        string memory name = getNameByCommentId(_id);
        address to = nameToAddr[name];
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
}