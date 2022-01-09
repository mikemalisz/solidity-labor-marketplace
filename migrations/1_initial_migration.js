const IdManager = artifacts.require('IdManager')
const LaborMarketplace = artifacts.require('LaborMarketplace')
LaborMarketplace.defaults({
	gasPrice: 0,
})

module.exports = async function (deployer) {
	await deployer.deploy(IdManager)
	await deployer.deploy(LaborMarketplace)
}
