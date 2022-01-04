const LaborMarketplace = artifacts.require('LaborMarketplace')

module.exports = function (deployer) {
	deployer.deploy(LaborMarketplace)
}
