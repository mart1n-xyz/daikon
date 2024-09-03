pragma solidity >=0.8.0 <0.9.0;

interface IGovernorFactory {
    function deployGovernor(address token, string memory name) external returns (address);
}
