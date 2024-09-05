pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {VestingWallet} from "./VestingWallet.sol";
import "../interfaces/IVestingWallet.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract VestingFactory is Ownable {
    address public graduationCeremonyContract;

    // Add mapping for Daikon to vesting contract
    mapping(address => address) public daikonToVesting;

    event VestingWalletCreated(address indexed token, address vestingWallet);

    // Update the constructor to call the Ownable constructor
    constructor() Ownable(msg.sender) {}

    // Add a function to set the graduation ceremony contract address
    function setGraduationCeremonyContract(address _graduationCeremonyContract) external onlyOwner {
        require(graduationCeremonyContract == address(0), "Graduation ceremony contract already set");
        graduationCeremonyContract = _graduationCeremonyContract;
    }

    function deployVesting(address token) external returns (address) {
        require(msg.sender == graduationCeremonyContract, "Caller is not the Graduation Ceremony contract");
        
        uint64 startTimestamp = uint64(block.timestamp);
        uint64 durationSeconds = 4 * 365 days; // 4 years

        VestingWallet vestingWallet = new VestingWallet(
            address(0), // Set beneficiary to zero address
            startTimestamp,
            durationSeconds
        );

        // Cast to IVestingWallet and transfer ownership
        IVestingWallet(address(vestingWallet)).transferOwnership(graduationCeremonyContract);

        // Add the mapping entry
        daikonToVesting[token] = address(vestingWallet);

        emit VestingWalletCreated(token, address(vestingWallet));

        return address(vestingWallet);
    }
}
