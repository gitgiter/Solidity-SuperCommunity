pragma solidity ^0.4.24;

contract CommentManager {

    struct Comment {

        // required
        uint id;
        string name;    // the user who make this comment
        string text;

        // optional
        string head_img;   // an image url
        uint blocktime;    // the unix time (seconds from 1970 to now)
    }

    Comment[] comments; // all the comments

    mapping(uint => uint) commentIdToWei; // mapping a comment id to all the rewards it received so far

    modifier commentCheck(string _comment) {

        // the length of a comment must greater than 0
        require(bytes(_comment).length > 0, "the length of a comment must greater than 0");

        // all checks are ok
        _;
    }

    function addComment(string _name, string _comment, string _head_img) public commentCheck(_comment) returns(bool) {

        // add a comment
        uint id = comments.push(Comment(0, _name, _comment, _head_img, block.timestamp)) - 1;

        // set id
        comments[id].id = id;

        return true;
    }

    // function getCommetsByName(string _name) public view returns(Comment[]) {

    //     // return all the comments made by a user
    //     Comment[] memory userComments;
    //     for (uint i = 0; i < comments.length; i++) {
    //         if (keccak256(abi.encodePacked(_name)) == keccak256(abi.encodePacked(comments[i].name))) {
    //             userComments.push(comments[i]);
    //         }
    //     } 
    //     return userComments;
    // }

    modifier balanceCheck() {

        // balance - msg.value must greater than 0
        require(msg.sender.balance - msg.value > 0, "balance not enough.");

        _;
    }

    modifier validAddress(address _addr) {

        // address cannot be 0x0
        require(_addr != address(0), "invalid address.");

        _;
    }

    function getNameByCommentId(uint _id) public view returns(string) {

        // get a username by comment id
        return comments[_id].name;
    }

    function rewardByAddr(address to, uint _id) public         
        validAddress(to)
        balanceCheck 
        payable returns(bool) {

        // reward a user directly
        to.transfer(msg.value); // left some for gas?

        // reward a comment by id
        commentIdToWei[_id] += msg.value;

        return true;
    }
}