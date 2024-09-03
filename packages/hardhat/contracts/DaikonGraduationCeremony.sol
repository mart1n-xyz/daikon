//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "../interfaces/IDaikonFactory.sol";
import "../interfaces/IERC20Factory.sol";
import "../interfaces/IGovernorFactory.sol";
import "../interfaces/IVestingFactory.sol";
import "../artifacts/@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DaikonGraduationCeremony {
    IDaikonFactory public daikonFactory;
    IERC20Factory public erc20Factory;
    IGovernorFactory public governorFactory;
    IVestingFactory public vestingFactory;

    // Mapping to track if a user has claimed their ERC20 tokens for a specific Daikon
    mapping(uint256 => mapping(address => bool)) public hasClaimed;

    // Mapping to store the ERC20 token address for each graduated Daikon
    mapping(uint256 => address) public daikonToERC20Token;

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

        // Deploy ERC20 token with 17,000,000 tokens (10M + 5M + 2M)
        uint256 totalTokens = 17000000 * 1e18; // Assuming 18 decimal places
        address erc20Token = erc20Factory.deployERC20(daikon.name, daikon.symbol, totalTokens);

        // Store the ERC20 token address for this Daikon
        daikonToERC20Token[_daikonId] = erc20Token;

        // TODO: Implement logic to distribute tokens, set up initial governance, etc.

       // emit DaikonGraduated(_daikonId, daikon.deployer, erc20Token, governor, vestingContract);
    }

    // New function for claiming ERC20 tokens
    function claimERC20Allocation(uint256 _daikonId) public {
        IDaikonFactory.Daikon memory daikon = daikonFactory.getDaikon(_daikonId);
        require(daikon.phase == 3, "Daikon must be graduated");
        require(!hasClaimed[_daikonId][msg.sender], "Tokens already claimed");

        // 1. Check the user's seed balance for the given Daikon
        uint256 userSeedBalance = getUserSeedBalance(_daikonId, msg.sender);
        require(userSeedBalance > 0, "No seeds to claim");

         // 2. Calculate the corresponding ERC20 token allocation
        uint256 totalSupply = 10000000 * 1e18; // Assuming 18 decimal places
        uint256 tokenAllocation = (userSeedBalance * totalSupply) / daikon.totalSeeds;

        // 3. Transfer the ERC20 tokens to the user
        address erc20Token = getERC20TokenAddress(_daikonId);
        require(IERC20(erc20Token).transfer(msg.sender, tokenAllocation), "Token transfer failed");

        // 4. Mark the user as having claimed their tokens
        hasClaimed[_daikonId][msg.sender] = true;
    }

    function getUserSeedBalance(uint256 _daikonId, address user) internal view returns (uint256) {
        return daikonFactory.getUserSeeds(_daikonId, user);
    }

    // Update the getERC20TokenAddress function to use the stored address
    function getERC20TokenAddress(uint256 _daikonId) internal view returns (address) {
        address tokenAddress = daikonToERC20Token[_daikonId];
        require(tokenAddress != address(0), "ERC20 token not found for this Daikon");
        return tokenAddress;
    }
}