var Migrations = artifacts.require("./carrierCore.sol");

module.exports = function(deployer) {
  deployer.deploy(Migrations);
};
