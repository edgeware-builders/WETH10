module.exports = async function ({deployments, getNamedAccounts}) {
  const {deploy} = deployments;
  const {deployer} = await getNamedAccounts();
  await deploy("WedgConverter", {
    from: deployer,
    deterministicDeployment: true,
    log: true
  });
}
