//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

// Useful for debugging. Remove when deploying to a live network.
import "hardhat/console.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

contract DaikonLaunchpad is Ownable {
    event DaikonCreated(uint256 indexed daikonId, address indexed owner, string name, string symbol);
    
    struct Daikon {
        uint256 id;
        address deployer;
        string name;
        string symbol;
        uint256 creationTime;
        uint256 totalContributions;
    }

    Daikon[] public daikons;
    mapping(address => uint256[]) public deployerToDaikonIds;

    constructor() Ownable() {}

    /**
     * Create a new Daikon within the registry
     * @param _name The initial name for the Daikon
     * @param _symbol The symbol for the Daikon's token
     */
    function createDaikon(string memory _name, string memory _symbol) public returns (uint256) {
        uint256 newDaikonId = daikons.length;
        daikons.push(Daikon(newDaikonId, msg.sender, _name, _symbol, block.timestamp, 0));
        deployerToDaikonIds[msg.sender].push(newDaikonId);
        emit DaikonCreated(newDaikonId, msg.sender, _name, _symbol);
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
     * Get Daikons deployed by an address
     */
    function getDaikonsByDeployer(address _deployer) public view returns (uint256[] memory) {
        return deployerToDaikonIds[_deployer];
    }

    /**
     * Contribute ETH to a Daikon
     */
    function contributeToDaikon(uint256 _daikonId) public payable {
        require(_daikonId < daikons.length, "Daikon does not exist");
        require(msg.value > 0, "Contribution must be greater than 0");
        
        Daikon storage daikon = daikons[_daikonId];
        daikon.totalContributions += msg.value;
        
        // Additional logic for handling contributions can be added here
    }

    /**
     * Get total contributions for a Daikon
     */
    function getDaikonContributions(uint256 _daikonId) public view returns (uint256) {
        require(_daikonId < daikons.length, "Daikon does not exist");
        return daikons[_daikonId].totalContributions;
    }
}
