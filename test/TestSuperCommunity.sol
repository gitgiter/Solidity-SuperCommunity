pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/SuperCommunity.sol";

contract TestMetacoin {

    function testRegister() public {
        SuperCommunity sc = SuperCommunity(DeployedAddresses.SuperCommunity());

        sc.register("test1");
        string memory expected = "test1";
        string memory result;
        (result,,,,) = sc.getUserByIndex(0);

        Assert.equal(result, expected, "fail to register");
    }

    function testInitialBalanceWithNewMetaCoin() public {
        SuperCommunity sc = new SuperCommunity();

        sc.sendComment("hhhh");
        string memory expected = "hhhh";
        string memory result;
        (result,,,) = sc.getCommentByIndex(0);

        Assert.equal(result, expected, "fail to send comment");
    }

}
