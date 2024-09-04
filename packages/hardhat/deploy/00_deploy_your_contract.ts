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
  const vestingFactory = await hre.ethers.getContractAt("VestingFactory", VestingFactory.address);
  await vestingFactory.setGraduationCeremonyAddress(DaikonGraduationCeremony.address);
  console.log("✅ Graduation ceremony address set in VestingFactory");

  // Set the graduation ceremony address in the DaikonLaunchpad
  const daikonLaunchpad = await hre.ethers.getContractAt("DaikonLaunchpad", DaikonLaunchpad.address);
  await daikonLaunchpad.setGraduationCeremonyAddress(DaikonGraduationCeremony.address);
  console.log("✅ Graduation ceremony address set in DaikonLaunchpad");
};

export default deployContracts;

deployContracts.tags = ["DaikonContracts"];
