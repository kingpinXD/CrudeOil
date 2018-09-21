var Migrations = artifacts.require("./math/SafeMath.sol");

module.exports = function(deployer) {
  deployer.deploy(Migrations);
};
