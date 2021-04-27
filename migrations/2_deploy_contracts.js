const WETH10 = artifacts.require('WETH10');

module.exports = function (deployer) {
    deployer.deploy(WETH10);
};
  