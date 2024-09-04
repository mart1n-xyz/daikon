pragma solidity >=0.8.0 <0.9.0;

interface IVestingFactory {
    function graduationCeremonyContract() external view returns (address);
    function daikonToVesting(address) external view returns (address);
    function deployVesting(address token) external returns (address);
    
    event VestingWalletCreated(address indexed token, address vestingWallet);
}
