const IdManager = artifacts.require('IdManager')
const LaborMarketplace = artifacts.require('LaborMarketplace')

module.exports = async function (deployer) {
	await deployer.deploy(IdManager)
	await deployer.deploy(LaborMarketplace)
}
