pragma solidity >=0.8.0 <0.9.0;

interface IVestingFactory {
    function deployVesting(address token, address beneficiary) external returns (address);
}
