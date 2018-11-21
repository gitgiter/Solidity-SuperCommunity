pragma solidity ^0.4.24;

contract MailManager {
    
    struct Mail {
        // required
        uint id;
        string from;
        string to;
        string title;
        string text;

        // optional
        bytes attachment;
    }

    // since mail box is private, there is no global mail box

    mapping(address => Mail[]) public nameToMailBox; // mapping a address to a mail box;

    function addMail(string _from, string _to, string _title, string _text) internal {

        // add a mail to the mail box
        uint id = nameToMailBox[msg.sender].push(Mail(0, _from, _to, _title, _text, "null")) - 1;

        // set id
        nameToMailBox[msg.sender][id].id = id;
    }

    function setAttachment(uint _id, bytes _attachment) public {
        
        // set attachment
        nameToMailBox[msg.sender][_id].attachment = _attachment;
    }
}