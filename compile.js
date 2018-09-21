const path = require("path");

// fs-extra adds file system methods that aren't included in the native fs module
// and adds promise support to the fs methods.
const fs = require("fs-extra");

const solc = require("solc");

const buildPath = path.resolve(__dirname, "build");
fs.removeSync(buildPath);

// It returns exhibition.sol path
const contractPath = path.resolve(__dirname, "contracts", "carrierBase.sol");

const exhibitionSource = fs.readFileSync(contractPath, "utf8");

const output = solc.compile(exhibitionSource, 1).contracts;

fs.ensureDirSync(buildPath);

for (let contract in output) {
  fs.outputJsonSync(
    path.resolve(buildPath, contract.replace(":", "") + ".json"),
    output[contract]
  );
}

//module.exports = output[":carrierBase"];
