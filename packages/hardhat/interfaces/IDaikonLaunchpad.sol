// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IDaikonLaunchpad {
    struct Daikon {
        string name;
        string symbol;
        uint256 totalSeeds;
        uint256 totalContributions;
        uint8 phase;
        address deployer;
    }

    function createDaikon(string memory _name, string memory _symbol, uint256 _contributionPeriod, string memory _data) external returns (uint256);
    function getDaikonCount() external view returns (uint256);
    function getDaikon(uint256 _daikonId) external view returns (Daikon memory);
    function getDaikonsByDeployer(address _deployer) external view returns (uint256[] memory);
    function contributeToDaikon(uint256 _daikonId) external payable;
    function getDaikonContributions(uint256 _daikonId) external view returns (uint256);
    function getUserContributions(uint256 _daikonId, address _user) external view returns (uint256);
    function getUserSeeds(uint256 _daikonId, address _user) external view returns (uint256);
    function maxContribution() external view returns (uint256);
    function maxContributionWithBuffer() external view returns (uint256);
    function isStewardCandidate(uint256 _daikonId, address _candidate) external view returns (bool);
}

