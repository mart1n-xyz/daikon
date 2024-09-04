// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../artifacts/@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../artifacts/@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "../artifacts/@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";

contract ERC20Factory {
    event TokenCreated(address indexed tokenAddress, string name, string symbol, uint256 initialSupply);

    function deployERC20(string memory name, string memory symbol, uint256 initialSupply) public returns (address) {
        CustomERC20 newToken = new CustomERC20(name, symbol, initialSupply);
        emit TokenCreated(address(newToken), name, symbol, initialSupply);
        return address(newToken);
    }
}

contract CustomERC20 is ERC20, ERC20Permit, ERC20Votes {
    constructor(string memory name, string memory symbol, uint256 initialSupply) ERC20(name, symbol) ERC20Permit(name) {
        _mint(msg.sender, initialSupply);
    }

    // The functions below are overrides required by Solidity.

    function _update(address from, address to, uint256 amount) internal override(ERC20, ERC20Votes) {
        super._update(from, to, amount);
    }


}
