// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IVestingFactory {
    function graduationCeremonyContract() external view returns (address);
    function daikonToVesting(address) external view returns (address);
    function deployVesting(address token) external returns (address);
    function setGraduationCeremonyContract(address _graduationCeremonyContract) external;

    event VestingWalletCreated(address indexed token, address vestingWallet);
}
