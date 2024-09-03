pragma solidity >=0.8.0 <0.9.0;

interface IDaikonFactory {
    struct Daikon {
        string name;
        string symbol;
        uint256 totalSeeds;
        uint256 totalContributions;
        uint8 phase;
        address deployer;
    }

    function getDaikon(uint256 _daikonId) external view returns (Daikon memory);

    function registerAsStewardCandidate(uint256 _daikonId) external payable;

    function getStewardCandidates(uint256 _daikonId) external view returns (address[] memory);

    function getStewardCandidateCount(uint256 _daikonId) external view returns (uint256);

    function updateMaxContribution(uint256 _newMaxContribution) external;

    function maxContribution() external view returns (uint256);

    function maxContributionWithBuffer() external view returns (uint256);
}

