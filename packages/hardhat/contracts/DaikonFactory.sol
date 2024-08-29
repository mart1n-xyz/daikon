//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

// Useful for debugging. Remove when deploying to a live network.
import "hardhat/console.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

contract Daikon is Ownable {
    constructor() Ownable(msg.sender) {}
    function getOwner() public view returns (address) {
        return owner();
}

receive() external payable {}

contract DaikonFactory is Ownable {


    function getOwner() public view returns (address) {
        return owner();
    }

    receive() external payable {}

    /**
     * Deploy a new Daikon contract
     */
    function deployDaikon(address owner) public returns (address) {
        Daikon newDaikon = new Daikon();
        address newOwner = owner == address(0) ? msg.sender : owner;
        newDaikon.transferOwnership(newOwner);
        return address(newDaikon);
    }
}

