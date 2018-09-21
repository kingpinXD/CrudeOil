var Migrations = artifacts.require("./crudeOil.sol");

module.exports = function(deployer) {
  deployer.deploy(Migrations);
};
