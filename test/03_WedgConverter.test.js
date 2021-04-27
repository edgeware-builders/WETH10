const WEDG9 = artifacts.require('WEDG9')
const WEDG10 = artifacts.require('WEDG10')
const WedgConverter = artifacts.require('WedgConverter')

const { BN, expectRevert } = require('@openzeppelin/test-helpers')
const { web3 } = require('@openzeppelin/test-helpers/src/setup')
require('chai').use(require('chai-as-promised')).should()

contract('WedgConverter', (accounts) => {
  const [deployer, user1, user2, user3] = accounts
  let wedg9, wedg10, wedgConverter

  beforeEach(async () => {
    wedg9 = await WEDG9.new({ from: deployer })
    wedg10 = await WEDG10.new({ from: deployer })
    wedgConverter = await WedgConverter.new({ from: deployer })

    await wedg9.deposit({ from: user1, value: 1 })
    await wedg10.deposit({ from: user2, value: 1 })
  })

  describe('deployment', async () => {
    it('converts from wedg9 to wedg10', async () => {
      await wedg9.approve(wedgConverter.address, 1, { from: user1 })
      await wedgConverter.wedg9ToWedg10(wedg9.address, wedg10.address, user1, 1, { from: user1 })
      const balanceAfter = await wedg10.balanceOf(user1)
      balanceAfter.toString().should.equal('1')
    })

    it('converts from wedg10 to wedg9', async () => {
      await wedg10.approve(wedgConverter.address, 1, { from: user2 })
      await wedgConverter.wedg10ToWedg9(wedg9.address, wedg10.address, user2, 1, { from: user2 })
      const balanceAfter = await wedg9.balanceOf(user2)
      balanceAfter.toString().should.equal('1')
    })
  })
})
