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
        string attachment;
    }

    // since mail box is private, there is no global mail box

    mapping(address => Mail[]) public addrToMailBox; // mapping a address to a mail box;

    function addMail(string _from, string _to, string _title, string _text) internal {

        // add a mail to the mail box
        uint id = addrToMailBox[msg.sender].push(Mail(0, _from, _to, _title, _text, "null")) - 1;

        // set id
        addrToMailBox[msg.sender][id].id = id;
    }

    function setAttachment(uint _id, string _attachment) public {
        
        // set attachment
        addrToMailBox[msg.sender][_id].attachment = _attachment;
    }

    function getMailByIndex(uint _index) public view returns(string, string, string, string, string) {

        Mail memory mail = addrToMailBox[msg.sender][_index];
        return (mail.from, mail.to, mail.title, mail.text, mail.attachment);
    }

    function getMailCount() public view returns(uint) {

        return addrToMailBox[msg.sender].length;
    }
}