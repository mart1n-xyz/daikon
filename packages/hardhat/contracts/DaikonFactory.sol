//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

// Useful for debugging. Remove when deploying to a live network.
import "hardhat/console.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

contract Daikon is Ownable {
    constructor(string memory _initialName) Ownable() {
        name = _initialName;
    }

    string public name;

    function setName(string memory _newName) public onlyOwner {
        name = _newName;
    }
}

contract DaikonFactory is Ownable {
    event DaikonDeployed(address indexed daikonAddress, address indexed owner, string name);

    constructor() Ownable() {}

    /**
     * Deploy a new Daikon contract
     * @param _name The initial name for the Daikon
     */
    function deployDaikon(string memory _name) public returns (address) {
        Daikon newDaikon = new Daikon(_name);
        newDaikon.transferOwnership(msg.sender);
        emit DaikonDeployed(address(newDaikon), msg.sender, _name);
        console.log("New Daikon deployed at:", address(newDaikon));
        return address(newDaikon);
    }
}
