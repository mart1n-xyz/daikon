// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IVestingWallet {
    // Events
    event EtherReleased(uint256 amount);
    event ERC20Released(address indexed token, uint256 amount);
    event BeneficiaryChanged(address indexed oldBeneficiary, address indexed newBeneficiary);

    // VestingWallet functions
    function start() external view returns (uint256);
    function duration() external view returns (uint256);
    function end() external view returns (uint256);
    function released() external view returns (uint256);
    function released(address token) external view returns (uint256);
    function releasable() external view returns (uint256);
    function releasable(address token) external view returns (uint256);
    function release() external;
    function release(address token) external;
    function vestedAmount(uint64 timestamp) external view returns (uint256);
    function vestedAmount(address token, uint64 timestamp) external view returns (uint256);
    function changeBeneficiary(address newBeneficiary) external;
    function beneficiary() external view returns (address);

    // Ownable functions
    function owner() external view returns (address);
    function transferOwnership(address newOwner) external;
    function renounceOwnership() external;
}
