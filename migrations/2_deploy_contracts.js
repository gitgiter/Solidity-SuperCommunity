// var UserManager = artifacts.require("./UserManager.sol");
// var CommentManager = artifacts.require("./CommentManager.sol");
// var MailManager = artifacts.require("./MailManager.sol");
// var Ownable = artifacts.require("./Ownable.sol");
// var CharityManager = artifacts.require("./CharityManager.sol");
// var GameManager = artifacts.require("./GameManager.sol");
var SuperCommunity = artifacts.require("./SuperCommunity.sol");

module.exports = function(deployer) {
  // deployer.deploy(UserManager);
  // deployer.deploy(CommentManager);
  // deployer.deploy(MailManager);
  // deployer.deploy(Ownable);
  // deployer.deploy(CharityManager);
  // deployer.deploy(GameManager);
  deployer.deploy(SuperCommunity);
};
