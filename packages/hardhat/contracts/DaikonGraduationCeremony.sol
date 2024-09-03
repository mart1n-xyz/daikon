//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "./interfaces/IDaikonFactory.sol";
import "./interfaces/IERC20Factory.sol";
import "./interfaces/IGovernorFactory.sol";
import "./interfaces/IVestingFactory.sol";

contract DaikonGraduationCeremony {
    IDaikonFactory public daikonFactory;
    IERC20Factory public erc20Factory;
    IGovernorFactory public governorFactory;
    IVestingFactory public vestingFactory;

    event DaikonGraduated(uint256 indexed daikonId, address indexed owner, address erc20Token, address governor, address vestingContract);

    constructor(
        address _daikonFactoryAddress,
        address _erc20FactoryAddress,
        address _governorFactoryAddress,
        address _vestingFactoryAddress
    ) {
        daikonFactory = IDaikonFactory(_daikonFactoryAddress);
        erc20Factory = IERC20Factory(_erc20FactoryAddress);
        governorFactory = IGovernorFactory(_governorFactoryAddress);
        vestingFactory = IVestingFactory(_vestingFactoryAddress);
    }

    function graduateDaikon(uint256 _daikonId) public {
        IDaikonFactory.Daikon memory daikon = daikonFactory.getDaikon(_daikonId);
        require(daikon.phase == 3, "Daikon must be in Phase 3 to graduate");

        // Deploy ERC20 token
        address erc20Token = erc20Factory.deployERC20(daikon.name, daikon.symbol, daikon.totalSeeds);

        // Deploy Governor contract
        address governor = governorFactory.deployGovernor(erc20Token, daikon.name);

        // Deploy Vesting contract
        address vestingContract = vestingFactory.deployVesting(erc20Token, daikon.deployer);

        // TODO: Implement logic to distribute tokens, set up initial governance, etc.

        emit DaikonGraduated(_daikonId, daikon.deployer, erc20Token, governor, vestingContract);
    }
}