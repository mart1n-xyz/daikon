import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";

const deployContracts: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployer } = await hre.getNamedAccounts();
  const { deploy } = hre.deployments;

  // Deploy ERC20Factory
  const ERC20Factory = await deploy("ERC20Factory", {
    from: deployer,
    args: [],
    log: true,
    autoMine: true,
  });
  console.log("👋 ERC20Factory deployed at:", ERC20Factory.address);

  // Deploy VestingFactory
  const VestingFactory = await deploy("VestingFactory", {
    from: deployer,
    args: [], // We'll set the graduation ceremony address later
    log: true,
    autoMine: true,
  });
  console.log("👋 VestingFactory deployed at:", VestingFactory.address);

  // Deploy GovernorFactory
  const GovernorFactory = await deploy("GovernorFactory", {
    from: deployer,
    args: [],
    log: true,
    autoMine: true,
  });
  console.log("👋 GovernorFactory deployed at:", GovernorFactory.address);

  // Deploy DaikonLaunchpad
  const DaikonLaunchpad = await deploy("DaikonLaunchpad", {
    from: deployer,
    args: [],
    log: true,
    autoMine: true,
  });
  console.log("👋 DaikonLaunchpad deployed at:", DaikonLaunchpad.address);

  // Deploy DaikonGraduationCeremony
  const DaikonGraduationCeremony = await deploy("DaikonGraduationCeremony", {
    from: deployer,
    args: [DaikonLaunchpad.address, ERC20Factory.address, GovernorFactory.address, VestingFactory.address],
    log: true,
    autoMine: true,
  });
  console.log("👋 DaikonGraduationCeremony deployed at:", DaikonGraduationCeremony.address);

  // Set the graduation ceremony address in the VestingFactory
  try {
    const vestingFactory = await hre.ethers.getContractAt("VestingFactory", VestingFactory.address);
    await vestingFactory.setGraduationCeremonyContract(DaikonGraduationCeremony.address);
    console.log("✅ Graduation ceremony address set in VestingFactory");
  } catch (error) {
    console.error("❌ Error setting graduation ceremony address in VestingFactory:", error);
  }

  // Set the graduation ceremony address in the ERC20Factory
  try {
    const erc20Factory = await hre.ethers.getContractAt("ERC20Factory", ERC20Factory.address);
    await erc20Factory.setGraduationCeremony(DaikonGraduationCeremony.address);
    console.log("✅ Graduation ceremony address set in ERC20Factory");
  } catch (error) {
    console.error("❌ Error setting graduation ceremony address in ERC20Factory:", error);
  }

  // Set the graduation ceremony address in the DaikonLaunchpad
  try {
    const daikonLaunchpad = await hre.ethers.getContractAt("DaikonLaunchpad", DaikonLaunchpad.address);
    await daikonLaunchpad.setGraduationCeremonyAddress(DaikonGraduationCeremony.address);
    console.log("✅ Graduation ceremony address set in DaikonLaunchpad");
  } catch (error) {
    console.error("❌ Error setting graduation ceremony address in DaikonLaunchpad:", error);
  }

  // Set the graduation ceremony address in the GovernorFactory
  try {
    const governorFactory = await hre.ethers.getContractAt("GovernorFactory", GovernorFactory.address);
    await governorFactory.setGraduationCeremony(DaikonGraduationCeremony.address);
    console.log("✅ Graduation ceremony address set in GovernorFactory");
  } catch (error) {
    console.error("❌ Error setting graduation ceremony address in GovernorFactory:", error);
  }
};

export default deployContracts;

deployContracts.tags = ["DaikonContracts"];
