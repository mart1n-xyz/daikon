// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

interface IERC20Factory {
    function deployERC20(string memory name, string memory symbol, uint256 initialSupply) external returns (address);

    event TokenCreated(address indexed tokenAddress, string name, string symbol, uint256 initialSupply);
}
