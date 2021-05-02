const SafeMath = artifacts.require('SafeMath');
const MezzCoin = artifacts.require('MezzCoin');

module.exports = (deployer) => {
  deployer.deploy(SafeMath);
  deployer.link(SafeMath, MezzCoin);
  deployer.deploy(MezzCoin, 1000, 'Mezz', '2', 1000, 'Mezz');
};
