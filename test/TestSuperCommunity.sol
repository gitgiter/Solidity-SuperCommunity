pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/SuperCommunity.sol";

contract TestSuperCommunity {

    SuperCommunity sc;

    constructor() public {

        sc = SuperCommunity(DeployedAddresses.SuperCommunity());
    } 

    function testRegiser() public {

        sc.register("test1");
        string memory expected = "test1";
        string memory result;
        (result,,,,) = sc.getUserByIndex(0);

        Assert.equal(result, expected, "fail to register test1");
    }

    function testGetUserCount() public {

        uint expected = 1;
        uint result = sc.getUserCount();
        
        Assert.equal(result, expected, "get user count error");
    }

    function testWatch() public {

        sc.watch("test1");
        string memory expected = "test1";
        string memory result;
        result = sc.getWatchesByIndex(0);

        Assert.equal(result, expected, "watch error");
    }
     
    function testGetWatchCount() public {

        uint expected = 1;
        uint result = sc.getWatchesCount();
        
        Assert.equal(result, expected, "get watch count error");
    }

    function testUnwatch() public {

        sc.unwatch("test1");
        string memory expected = "";
        string memory result;
        result = sc.getWatchesByIndex(0);

        Assert.equal(result, expected, "unwatch error");
    }

    function testSendComment() public {

        sc.sendComment("hhhh");
        string memory expected = "hhhh";
        string memory result;
        (,result,,) = sc.getCommentByIndex(0);

        Assert.equal(result, expected, "fail to send comment");
    }

    function testGetCommentCount() public {

        uint expected = 1;
        uint result = sc.getCommentCount();
        
        Assert.equal(result, expected, "get comment count error");
    }
    
    function testSendMail() public {

        sc.sendMail("test1", "title1", "text1");
        string memory expected = "test1";
        string memory result;
        (,result,,,) = sc.getMailByIndex(0);

        Assert.equal(result, expected, "fail to send mail");
    }

    function testGetMailCount() public {

        uint expected = 1;
        uint result = sc.getMailCount();
        
        Assert.equal(result, expected, "get mail count error");
    }

}
