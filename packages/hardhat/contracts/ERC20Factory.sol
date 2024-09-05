// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
import "@openzeppelin/contracts/utils/Nonces.sol";
import "@openzeppelin/contracts/access/Ownable.sol"; // Import Ownable

contract ERC20Factory is Ownable { // Inherit Ownable
    address public graduationCeremony;
    bool public graduationCeremonySet;

    event TokenCreated(address indexed tokenAddress, string name, string symbol, uint256 initialSupply);

    // Initialize Ownable in the constructor
    constructor() Ownable(msg.sender) {}

    // Function to set the graduation ceremony address
    function setGraduationCeremony(address _graduationCeremony) external onlyOwner { // Only owner can call
        require(!graduationCeremonySet, "Graduation ceremony address already set");
        graduationCeremony = _graduationCeremony;
        graduationCeremonySet = true;
    }

    function deployERC20(string memory name, string memory symbol, uint256 initialSupply) public returns (address) {
        require(msg.sender == graduationCeremony, "Only graduation ceremony can call");
        CustomERC20 newToken = new CustomERC20(name, symbol, initialSupply);
        emit TokenCreated(address(newToken), name, symbol, initialSupply);
        return address(newToken);
    }
}

contract CustomERC20 is ERC20, ERC20Permit, ERC20Votes {
    constructor(string memory name, string memory symbol, uint256 initialSupply) ERC20(name, symbol) ERC20Permit(name) {
        _mint(msg.sender, initialSupply);
    }

    function nonces(address owner) public view virtual override(ERC20Permit, Nonces) returns (uint256) {
        return super.nonces(owner);
    }

    // The functions below are overrides required by Solidity.

    function _update(address from, address to, uint256 amount) internal override(ERC20, ERC20Votes) {
        super._update(from, to, amount);
    }
}
