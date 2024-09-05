pragma solidity ^0.8.20;

import "../artifacts/@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./VestingWallet.sol";
import "../interfaces/IVestingWallet.sol";

contract VestingFactory {
    address public immutable graduationCeremonyContract;

    // Add mapping for Daikon to vesting contract
    mapping(address => address) public daikonToVesting;

    event VestingWalletCreated(address indexed token, address vestingWallet);

    constructor(address _graduationCeremonyContract) {
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
