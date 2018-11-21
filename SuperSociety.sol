pragma solidity ^0.4.25;

import "./UserManager.sol";
import "./CommentManager.sol";

contract SuperSociety is UserManager, CommentManager {

    function sendComment(string _comment) public registered(msg.sender) {
        User memory user = addrToUser[msg.sender];
        addComment(user.name, _comment, user.head_img);
    }

    function rewardComment(uint _id) public existName(getNameByCommentId(_id)) {
        string memory name = getNameByCommentId(_id);
        address to = nameToAddr[name];
        rewardByAddr(to, _id);
    }
}