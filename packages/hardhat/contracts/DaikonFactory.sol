//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

// Useful for debugging. Remove when deploying to a live network.
import "hardhat/console.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

contract DaikonFactory is Ownable {
    event DaikonCreated(uint256 indexed daikonId, address indexed owner, string name);
    event DaikonNameChanged(uint256 indexed daikonId, string newName);

    struct Daikon {
        uint256 id;
        address owner;
        string name;
    }

    Daikon[] public daikons;
    mapping(address => uint256[]) public ownerToDaikonIds;

    constructor() Ownable() {}

    /**
     * Create a new Daikon within the registry
     * @param _name The initial name for the Daikon
     */
    function createDaikon(string memory _name) public returns (uint256) {
        uint256 newDaikonId = daikons.length;
        daikons.push(Daikon(newDaikonId, msg.sender, _name));
        ownerToDaikonIds[msg.sender].push(newDaikonId);
        emit DaikonCreated(newDaikonId, msg.sender, _name);
        console.log("New Daikon created with ID:", newDaikonId);
        return newDaikonId;
    }

    /**
     * Get the number of Daikons in the registry
     */
    function getDaikonCount() public view returns (uint256) {
        return daikons.length;
    }

    /**
     * Get Daikon info by ID
     */
    function getDaikon(uint256 _daikonId) public view returns (Daikon memory) {
        require(_daikonId < daikons.length, "Daikon does not exist");
        return daikons[_daikonId];
    }

    /**
     * Get Daikons owned by an address
     */
    function getDaikonsByOwner(address _owner) public view returns (uint256[] memory) {
        return ownerToDaikonIds[_owner];
    }

    /**
     * Set name for a Daikon
     */
    function setDaikonName(uint256 _daikonId, string memory _newName) public {
        require(_daikonId < daikons.length, "Daikon does not exist");
        require(daikons[_daikonId].owner == msg.sender, "Only Daikon owner can set name");
        daikons[_daikonId].name = _newName;
        emit DaikonNameChanged(_daikonId, _newName);
    }

    /**
     * Transfer ownership of a Daikon
     */
    function transferDaikonOwnership(uint256 _daikonId, address _newOwner) public {
        require(_daikonId < daikons.length, "Daikon does not exist");
        require(daikons[_daikonId].owner == msg.sender, "Only Daikon owner can transfer ownership");
        require(_newOwner != address(0), "New owner cannot be zero address");

        // Remove Daikon from current owner's list
        uint256[] storage currentOwnerDaikons = ownerToDaikonIds[msg.sender];
        for (uint i = 0; i < currentOwnerDaikons.length; i++) {
            if (currentOwnerDaikons[i] == _daikonId) {
                currentOwnerDaikons[i] = currentOwnerDaikons[currentOwnerDaikons.length - 1];
                currentOwnerDaikons.pop();
                break;
            }
        }

        // Add Daikon to new owner's list
        ownerToDaikonIds[_newOwner].push(_daikonId);

        // Update Daikon owner
        daikons[_daikonId].owner = _newOwner;
    }


}
