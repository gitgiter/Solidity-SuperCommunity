pragma solidity ^0.4.24;

contract CommentManager {

    struct Comment {

        // required
        uint id;
        string name;    // the user who make this comment
        string text;

        // optional
        string head_img;   // an image url
        uint time;    // the unix time (seconds from 1970 to now)
    }

    Comment[] comments; // all the comments

    mapping(uint => uint) commentIdToWei; // mapping a comment id to all the rewards it received so far

    modifier commentCheck(string memory _comment) {

        // the length of a comment must greater than 0
        require(bytes(_comment).length > 0, "the length of a comment must greater than 0");

        // all checks are ok
        _;
    }

    function addComment(string memory _name, string memory _comment, string memory _head_img) internal commentCheck(_comment) returns(bool) {

        // add a comment
        uint id = comments.push(Comment(0, _name, _comment, _head_img, now)) - 1;

        // set id
        comments[id].id = id;

        return true;
    }

    modifier validAddress(address _addr) {

        // address cannot be 0x0
        require(_addr != address(0), "invalid address.");

        _;
    }

    function getNameByCommentId(uint _id) public view returns(string memory) {

        // get a username by comment id
        return comments[_id].name;
    }

    function rewardByAddr(address _to, uint _id) public validAddress(_to) payable returns(address) {

        // reward a user directly
        _to.transfer(msg.value);

        // reward a comment by id
        commentIdToWei[_id] += msg.value;

        // for test
        return msg.sender;
    }

    function getCommentByIndex(uint _index) public view returns(string memory, string memory, string memory, uint) {

        
        Comment memory comment = comments[_index];
        return (comment.name, comment.text, comment.head_img, comment.time);
    }

    function getCommentCount() public view returns(uint) {

        return comments.length;
    }

    function getCommentBalanceByIndex(uint _index) public view returns(uint) {

        return commentIdToWei[_index];
    }
}