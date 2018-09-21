var Migrations = artifacts.require("./carrierBase.sol");

module.exports = function(deployer) {
  deployer.deploy(Migrations);
};
