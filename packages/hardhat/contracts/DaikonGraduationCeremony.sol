//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../interfaces/IDaikonLaunchpad.sol";
import "../interfaces/IERC20Factory.sol";
import "../interfaces/IGovernorFactory.sol";
import "../interfaces/IVestingFactory.sol";
import "../interfaces/IVestingWallet.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IVotes} from "@openzeppelin/contracts/governance/utils/IVotes.sol";


contract DaikonGraduationCeremony {
    IDaikonLaunchpad public daikonLaunchpad;
    IERC20Factory public erc20Factory;
    IGovernorFactory public governorFactory;
    IVestingFactory public vestingFactory;

    // Mapping to track if a user has claimed their ERC20 tokens for a specific Daikon
    mapping(uint256 => mapping(address => bool)) public hasClaimed;

    // Mapping to store the ERC20 token address for each graduated Daikon
    mapping(uint256 => address) public daikonToERC20Token;

    // New state variables
    mapping(uint256 => mapping(address => address)) public votes;
    mapping(uint256 => mapping(address => uint256)) public candidateVotes;
    mapping(uint256 => uint256) public graduationTimestamp;
    mapping(uint256 => address) public stewardWinner;

    event DaikonGraduated(uint256 indexed daikonId, address indexed owner, address erc20Token, address governor, address vestingContract);

    constructor(
        address _daikonLaunchpadAddress,
        address _erc20FactoryAddress,
        address _governorFactoryAddress,
        address _vestingFactoryAddress
    ) {
        daikonLaunchpad = IDaikonLaunchpad(_daikonLaunchpadAddress);
        erc20Factory = IERC20Factory(_erc20FactoryAddress);
        governorFactory = IGovernorFactory(_governorFactoryAddress);
        vestingFactory = IVestingFactory(_vestingFactoryAddress);
    }

    function graduateDaikon(uint256 _daikonId) public {
        IDaikonLaunchpad.Daikon memory daikon = daikonLaunchpad.getDaikon(_daikonId);
        require(daikon.phase == 5, "Daikon must be in graduated state");

        // Get the treasury amount from daikonLaunchpad
        uint256 treasuryAmount = daikon.totalContributions - 1 ether;
        require(address(this).balance >= treasuryAmount, "Insufficient balance for graduation");

        // Deploy ERC20 token
        address erc20Token = erc20Factory.deployERC20(daikon.name, daikon.symbol, 17000000 * 1e18); // Total supply: 17 million

        // Deploy Governor contract
        TimelockController timelock = new TimelockController(1 days, new address[](0), new address[](0), address(this));
        address governor = governorFactory.deployGovernor(string(abi.encodePacked(daikon.name, " Governor")), IVotes(erc20Token), timelock);

        // Deploy Vesting contract
        address vestingContract = vestingFactory.deployVesting(erc20Token);

        // Transfer treasury to Governor
        payable(address(timelock)).transfer(treasuryAmount);

        // Transfer ERC20 tokens to Governor, Vesting contract, and initialize token claims
        uint256 governorAllocation = 5000000 * 1e18; // 5 million tokens
        uint256 vestingAllocation = 2000000 * 1e18; // 2 million tokens
        IERC20(erc20Token).transfer(address(timelock), governorAllocation);
        IERC20(erc20Token).transfer(vestingContract, vestingAllocation);

        // Store the ERC20 token address for this Daikon
        daikonToERC20Token[_daikonId] = erc20Token;

        // Set the graduation timestamp
        graduationTimestamp[_daikonId] = block.timestamp;

        emit DaikonGraduated(_daikonId, daikon.deployer, erc20Token, governor, vestingContract);
    }

    function claimERC20Allocation(uint256 _daikonId, address _voteFor) public {
        IDaikonLaunchpad.Daikon memory daikon = daikonLaunchpad.getDaikon(_daikonId);
        require(daikon.phase == 5, "Daikon must be graduated");
        require(!hasClaimed[_daikonId][msg.sender], "Tokens already claimed");
        
        address erc20Token = daikonToERC20Token[_daikonId];
        require(erc20Token != address(0), "Daikon has not been graduated yet");

        // 1. Check the user's seed balance for the given Daikon
        uint256 userSeedBalance = daikonLaunchpad.getUserSeeds(_daikonId, msg.sender);
        require(userSeedBalance > 0, "No seeds to claim");

        // 2. Calculate the corresponding ERC20 token allocation
        uint256 totalSupply = 10000000 * 1e18; // 10 million tokens for seed holders
        uint256 totalSeeds = daikonLaunchpad.getDaikonSeeds(_daikonId);
        uint256 tokenAllocation = (userSeedBalance * totalSupply) / totalSeeds;

        // Voting logic
        if (block.timestamp <= graduationTimestamp[_daikonId] + 3 days) {
            address[] memory candidates = daikonLaunchpad.getStewardCandidates(_daikonId);
            if (candidates.length > 0) {
                require(daikonLaunchpad.isStewardCandidate(_daikonId, _voteFor), "Invalid candidate");
                votes[_daikonId][msg.sender] = _voteFor;
                candidateVotes[_daikonId][_voteFor] += tokenAllocation;
            }
        }

        require(IERC20(erc20Token).transfer(msg.sender, tokenAllocation), "Token transfer failed");

        // 4. Mark the user as having claimed their tokens
        hasClaimed[_daikonId][msg.sender] = true;
    }

    function calculateWinner(uint256 _daikonId) public {
        require(block.timestamp > graduationTimestamp[_daikonId] + 3 days, "Voting period not ended");
        require(stewardWinner[_daikonId] == address(0), "Winner already calculated");

        address[] memory candidates = daikonLaunchpad.getStewardCandidates(_daikonId);
        address winner = address(0);
        uint256 maxVotes = 0;

        for (uint256 i = 0; i < candidates.length; i++) {
            uint256 votes = candidateVotes[_daikonId][candidates[i]];
            if (votes > maxVotes) {
                maxVotes = votes;
                winner = candidates[i];
            }
        }

        stewardWinner[_daikonId] = winner;
        
        // Get the ERC20 token address for this Daikon
        address erc20Token = daikonToERC20Token[_daikonId];
        
        // Get the vesting contract address for this Daikon's ERC20 token
        address vestingContract = vestingFactory.daikonToVesting(erc20Token);
        
        // Reassign the vesting contract to the winner
        IVestingWallet(vestingContract).changeBeneficiary(winner);
    }

    function getUserSeedBalance(uint256 _daikonId, address user) internal view returns (uint256) {
        return daikonLaunchpad.getUserSeeds(_daikonId, user);
    }

    // Update the getERC20TokenAddress function to use the stored address
    function getERC20TokenAddress(uint256 _daikonId) internal view returns (address) {
        address tokenAddress = daikonToERC20Token[_daikonId];
        require(tokenAddress != address(0), "ERC20 token not found for this Daikon");
        return tokenAddress;
    }
}