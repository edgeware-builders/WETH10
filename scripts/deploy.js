async function main() {
  // We get the contract to deploy
  const WETH10Factory = await ethers.getContractFactory("WETH10");
  const WETH10 = await WETH10Factory.deploy();

  console.log("Greeter deployed to:", greeter.address);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });