//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

// Useful for debugging. Remove when deploying to a live network.
import "hardhat/console.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

contract DaikonLaunchpad is Ownable {
    event DaikonCreated(uint256 indexed daikonId, address indexed owner, string name, string symbol);
    event PhaseAdvanced(uint256 indexed daikonId, uint8 newPhase);
    event Contribution(uint256 indexed daikonId, address indexed contributor, uint256 amount);
    event SeedsAssigned(uint256 indexed daikonId, address indexed contributor, uint256 seedsAmount);
    event SeedsRedeemed(uint256 indexed daikonId, address indexed redeemer, uint256 seedsAmount, uint256 ethAmount);
    event PeriodicSaleStarted(uint256 indexed daikonId, uint256 indexed saleIndex, uint256 saleEndTimestamp, uint256 seedsForSale);
    event PeriodicSaleContribution(uint256 indexed daikonId, uint256 indexed saleIndex, address indexed contributor, uint256 amount);
    event PeriodicSaleEnded(uint256 indexed daikonId, uint256 indexed saleIndex, uint256 seedsAllocated, uint256 amountRaised, uint256 totalSeeds);
    
    struct Daikon {
        uint256 id;
        address deployer;
        string name;
        string symbol;
        uint256 creationTime;
        uint256 totalContributions;
        uint8 phase;
        uint256 nextPhaseTimestamp;
        bool seedsAssignable;
        string data; // JSON of links to socials, manifesto, description, and image
        uint256 totalSeeds; // Total seeds for this Daikon
        uint256 circulatingSeeds; // Current circulating seeds for this Daikon
        PeriodicSaleInfo periodicSaleInfo;
    }

    struct PeriodicSaleInfo {
        uint256 periodicSaleEndTimestamp;
        uint256 seedsForPeriodicSale;
        uint256 contributionsInCurrentSale;
        uint256 currentSaleIndex;
    }

    struct SaleRecord {
        uint256 seedsAllocated;
        uint256 amountRaised;
        uint256 totalSeeds;
    }

    Daikon[] public daikons;
    mapping(address => uint256[]) public deployerToDaikonIds;
    mapping(uint256 => mapping(address => uint256)) public userContributions;
    mapping(uint256 => mapping(address => uint256)) public userSeeds;
    mapping(uint256 => mapping(uint256 => mapping(address => uint256))) public periodicSaleContributions;
    mapping(uint256 => mapping(uint256 => SaleRecord)) public saleRecords;

    constructor() Ownable() {}
    /**
     * Create a new Daikon within the registry
     * @param _name The initial name for the Daikon
     * @param _symbol The symbol for the Daikon's token
     * @param _contributionPeriod The contribution period in days (1, 2, or 3)
     * @param _data JSON string containing links to socials, manifesto, description, and image
     * @param _totalSeeds The total number of seeds for this Daikon
     */
    function createDaikon(string memory _name, string memory _symbol, uint256 _contributionPeriod, string memory _data, uint256 _totalSeeds) public returns (uint256) {
        uint256 newDaikonId = daikons.length;
        uint256 contributionPeriodInDays = 3 days; // Default to 3 days

        if (_contributionPeriod == 1) {
            contributionPeriodInDays = 1 days;
        } else if (_contributionPeriod == 2) {
            contributionPeriodInDays = 2 days;
        }

        daikons.push(Daikon(
            newDaikonId,
            msg.sender,
            _name,
            _symbol,
            block.timestamp,
            0,
            1,
            block.timestamp + contributionPeriodInDays,
            false,
            _data,
            _totalSeeds,
            0,
            PeriodicSaleInfo(0, 0, 0, 0)
        ));
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
    
    function getDaikon(uint256 _daikonId) public view returns (Daikon memory) {
        require(_daikonId < daikons.length, "Daikon does not exist");
        return daikons[_daikonId];
    }
 */
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
        
        // Check and advance phase before processing contribution
        checkAndAdvancePhase(_daikonId);
        
        Daikon storage daikon = daikons[_daikonId];
        require(daikon.phase == 1, "Contributions are only allowed in phase 1");
        require(block.timestamp < daikon.nextPhaseTimestamp, "Contribution period has ended");
        
        require(daikon.totalContributions < 80 ether, "Total contributions already at or above 80 ETH");
        require(daikon.totalContributions + msg.value <= 80.05 ether, "Contribution would exceed 80.05 ETH total");
        
        daikon.totalContributions += msg.value;
        userContributions[_daikonId][msg.sender] += msg.value;
        
        emit Contribution(_daikonId, msg.sender, msg.value);
    }

    /**
     * Get total contributions for a Daikon
     */
    function getDaikonContributions(uint256 _daikonId) public view returns (uint256) {
        require(_daikonId < daikons.length, "Daikon does not exist");
        return daikons[_daikonId].totalContributions;
    }

    /**
     * Get user contributions for a specific Daikon
     */
    function getUserContributions(uint256 _daikonId, address _user) public view returns (uint256) {
        require(_daikonId < daikons.length, "Daikon does not exist");
        return userContributions[_daikonId][_user];
    }

    /**
     * Check and advance the phase of a Daikon if necessary
     * @param _daikonId The ID of the Daikon to check and potentially advance
     */
    function checkAndAdvancePhase(uint256 _daikonId) public {
        require(_daikonId < daikons.length, "Daikon does not exist");
        Daikon storage daikon = daikons[_daikonId];
        
        if (daikon.phase == 1 && block.timestamp >= daikon.nextPhaseTimestamp) {
            if (daikon.totalContributions >= 80 ether) {
                daikon.phase = 3;
            } else {
                daikon.phase = 2;
                startPeriodicSale(_daikonId);
            }
            daikon.nextPhaseTimestamp = type(uint256).max; // Set to max value to avoid interference
            daikon.seedsAssignable = true;
            emit PhaseAdvanced(_daikonId, daikon.phase);
        } else if (daikon.phase == 2 && daikon.totalContributions >= 80 ether) {
            daikon.phase = 3;
            emit PhaseAdvanced(_daikonId, daikon.phase);
        }
    }

    /**
     * Start a periodic sale for a Daikon
     * @param _daikonId The ID of the Daikon to start the sale for
     */
    function startPeriodicSale(uint256 _daikonId) internal {
        Daikon storage daikon = daikons[_daikonId];
        require(daikon.phase == 2, "Periodic sales are only allowed in phase 2");
        require(daikon.periodicSaleInfo.periodicSaleEndTimestamp == 0 || block.timestamp >= daikon.periodicSaleInfo.periodicSaleEndTimestamp, "Previous sale has not ended");

        daikon.periodicSaleInfo.periodicSaleEndTimestamp = block.timestamp + 3 days;
        daikon.periodicSaleInfo.seedsForPeriodicSale = daikon.totalSeeds / 10; // 10% of total seeds
        daikon.periodicSaleInfo.contributionsInCurrentSale = 0;
        daikon.periodicSaleInfo.currentSaleIndex++;

        emit PeriodicSaleStarted(_daikonId, daikon.periodicSaleInfo.currentSaleIndex, daikon.periodicSaleInfo.periodicSaleEndTimestamp, daikon.periodicSaleInfo.seedsForPeriodicSale);
    }

    /**
     * Contribute to the periodic sale of a Daikon
     * @param _daikonId The ID of the Daikon to contribute to
     */
    function contributeToPeriodicSale(uint256 _daikonId) public payable {
        require(_daikonId < daikons.length, "Daikon does not exist");
        Daikon storage daikon = daikons[_daikonId];
        
        // Check if a new sale needs to be started
        checkAndStartNewPeriodicSale(_daikonId);
        
        require(daikon.phase == 2, "Periodic sales are only allowed in phase 2");
        require(block.timestamp < daikon.periodicSaleInfo.periodicSaleEndTimestamp, "Periodic sale has ended");
        require(msg.value > 0, "Contribution must be greater than 0");

        // Check and claim seeds from phase 1 if available
        if (daikon.seedsAssignable && userContributions[_daikonId][msg.sender] > 0 && userSeeds[_daikonId][msg.sender] == 0) {
            claimSeeds(_daikonId);
        }

        daikon.periodicSaleInfo.contributionsInCurrentSale += msg.value;
        periodicSaleContributions[_daikonId][daikon.periodicSaleInfo.currentSaleIndex][msg.sender] += msg.value;

        emit PeriodicSaleContribution(_daikonId, daikon.periodicSaleInfo.currentSaleIndex, msg.sender, msg.value);

        if (daikon.totalContributions + daikon.periodicSaleInfo.contributionsInCurrentSale >= 80 ether) {
            endPeriodicSale(_daikonId);
            daikon.phase = 3;
            emit PhaseAdvanced(_daikonId, daikon.phase);
        }
    }

    /**
     * Check if the current sale has ended and start a new one if necessary
     * @param _daikonId The ID of the Daikon to check
     */
    function checkAndStartNewSale(uint256 _daikonId) public {
        require(_daikonId < daikons.length, "Daikon does not exist");
        Daikon storage daikon = daikons[_daikonId];
        require(daikon.phase == 2, "Periodic sales are only allowed in phase 2");

        if (block.timestamp >= daikon.periodicSaleInfo.periodicSaleEndTimestamp) {
            endPeriodicSale(_daikonId);
            if (daikon.phase == 2) {
                startPeriodicSale(_daikonId);
            }
        }
    }

    /**
     * End the current periodic sale and update total contributions
     * @param _daikonId The ID of the Daikon to end the sale for
     */
    function endPeriodicSale(uint256 _daikonId) internal {
        Daikon storage daikon = daikons[_daikonId];
        
        if (daikon.periodicSaleInfo.contributionsInCurrentSale == 0) {
            daikon.phase = 4;
            emit PhaseAdvanced(_daikonId, daikon.phase);
        } else {
            // Record the current sale
            saleRecords[_daikonId][daikon.periodicSaleInfo.currentSaleIndex] = SaleRecord(
                daikon.periodicSaleInfo.seedsForPeriodicSale,
                daikon.periodicSaleInfo.contributionsInCurrentSale,
                daikon.totalSeeds
            );

            // Update total contributions
            daikon.totalContributions += daikon.periodicSaleInfo.contributionsInCurrentSale;
            daikon.totalSeeds += daikon.periodicSaleInfo.seedsForPeriodicSale;

            emit PeriodicSaleEnded(_daikonId, daikon.periodicSaleInfo.currentSaleIndex, daikon.periodicSaleInfo.seedsForPeriodicSale, daikon.periodicSaleInfo.contributionsInCurrentSale, daikon.totalSeeds);
        }

        // Reset contributions for the next sale
        daikon.periodicSaleInfo.contributionsInCurrentSale = 0;
    }

    /**
     * Assign Daikon Seeds to the caller
     * @param _daikonId The ID of the Daikon to assign seeds for
     */
    function claimSeeds(uint256 _daikonId) public {
        require(_daikonId < daikons.length, "Daikon does not exist");
        Daikon storage daikon = daikons[_daikonId];
        require(daikon.seedsAssignable, "Seeds are not assignable yet");
        require(userContributions[_daikonId][msg.sender] > 0, "No contributions to claim seeds for");
        require(userSeeds[_daikonId][msg.sender] == 0, "Seeds have already been claimed");

        uint256 totalContributions = daikon.totalContributions;
        uint256 contribution = userContributions[_daikonId][msg.sender];
        
        // Use SafeMath for multiplication to prevent overflow
        uint256 scaledContribution = contribution * 1e18;
        uint256 seeds = (scaledContribution * daikon.totalSeeds) / totalContributions;
        
        // Round down to ensure total distributed seeds don't exceed totalSeeds
        seeds = seeds / 1e18;

        userSeeds[_daikonId][msg.sender] = seeds;
        daikon.circulatingSeeds += seeds;
        emit SeedsAssigned(_daikonId, msg.sender, seeds);
    }

    /**
     * Get user's Daikon Seeds for a specific Daikon
     */
    function getUserSeeds(uint256 _daikonId, address _user) public view returns (uint256) {
        require(_daikonId < daikons.length, "Daikon does not exist");
        return userSeeds[_daikonId][_user];
    }

    /**
     * Check if seeds were claimed and claim them if not
     * @param _daikonId The ID of the Daikon to check and potentially claim seeds for
     */
    function checkAndClaimSeeds(uint256 _daikonId) public {
        require(_daikonId < daikons.length, "Daikon does not exist");
        Daikon storage daikon = daikons[_daikonId];
        
        if (daikon.seedsAssignable && userContributions[_daikonId][msg.sender] > 0 && userSeeds[_daikonId][msg.sender] == 0) {
            claimSeeds(_daikonId);
        }
    }

    /**
     * Get total and circulating seeds for a Daikon
     */
    function getDaikonSeeds(uint256 _daikonId) public view returns (uint256 totalSeeds, uint256 circulatingSeeds) {
        require(_daikonId < daikons.length, "Daikon does not exist");
        Daikon storage daikon = daikons[_daikonId];
        return (daikon.totalSeeds, daikon.circulatingSeeds);
    }

    /**
     * Redeem Daikon Seeds for ETH
     * @param _daikonId The ID of the Daikon to redeem seeds from
     * @param _seedAmount The amount of seeds to redeem
     */
    function redeemSeeds(uint256 _daikonId, uint256 _seedAmount) public {
        require(_daikonId < daikons.length, "Daikon does not exist");
        Daikon storage daikon = daikons[_daikonId];
        
        // Check and advance phase if needed
        checkAndAdvancePhase(_daikonId);
        
        // Claim seeds if available
        checkAndClaimSeeds(_daikonId);
        
        require(daikon.phase == 2, "Seeds can only be redeemed in phase 2");
        require(userSeeds[_daikonId][msg.sender] >= _seedAmount, "Insufficient seeds to redeem");

        uint256 scaleFactor = 1e18;
        uint256 scaledRedeemableEth = (_seedAmount * daikon.totalContributions * scaleFactor) / daikon.totalSeeds;
        uint256 redeemableEth = scaledRedeemableEth / scaleFactor;
        require(redeemableEth > 0, "Redeemable amount too small");
        require(address(this).balance >= redeemableEth, "Insufficient contract balance");

        userSeeds[_daikonId][msg.sender] -= _seedAmount;
        daikon.circulatingSeeds -= _seedAmount;
        daikon.totalContributions -= redeemableEth;

        (bool sent, ) = msg.sender.call{value: redeemableEth}("");
        require(sent, "Failed to send Ether");

        emit SeedsRedeemed(_daikonId, msg.sender, _seedAmount, redeemableEth);

        checkAndStartNewPeriodicSale(_daikonId);
    }

    function checkAndStartNewPeriodicSale(uint256 _daikonId) internal {
        Daikon storage daikon = daikons[_daikonId];
        if (daikon.phase == 2 && (daikon.periodicSaleInfo.periodicSaleEndTimestamp == 0 || block.timestamp >= daikon.periodicSaleInfo.periodicSaleEndTimestamp)) {
            startPeriodicSale(_daikonId);
        }
    }

    /**
     * Claim seeds from a specific past periodic sale
     * @param _daikonId The ID of the Daikon
     * @param _saleId The ID of the past sale
     */
    function claimSeedsFromPastSale(uint256 _daikonId, uint256 _saleId) public {
        require(_daikonId < daikons.length, "Daikon does not exist");
        Daikon storage daikon = daikons[_daikonId];
        require(_saleId < daikon.periodicSaleInfo.currentSaleIndex, "Can only claim from past sales");
        require(periodicSaleContributions[_daikonId][_saleId][msg.sender] > 0, "No contributions to claim seeds for this sale");

        SaleRecord storage sale = saleRecords[_daikonId][_saleId];
        uint256 contribution = periodicSaleContributions[_daikonId][_saleId][msg.sender];
        
        // Use SafeMath for multiplication to prevent overflow
        uint256 scaledContribution = contribution * 1e18;
        uint256 seeds = (scaledContribution * sale.seedsAllocated) / sale.amountRaised;
        
        // Round down to ensure total distributed seeds don't exceed seedsAllocated
        seeds = seeds / 1e18;

        userSeeds[_daikonId][msg.sender] += seeds;
        daikon.circulatingSeeds += seeds;
        
        // Clear the contribution to prevent double claiming
        periodicSaleContributions[_daikonId][_saleId][msg.sender] = 0;

        emit SeedsAssigned(_daikonId, msg.sender, seeds);
    }

    /**
     * Claim seeds from all past periodic sales since the last claim
     * @param _daikonId The ID of the Daikon
     */
    function claimAllPendingSeeds(uint256 _daikonId) public {
        require(_daikonId < daikons.length, "Daikon does not exist");
        Daikon storage daikon = daikons[_daikonId];

        // Check and claim seeds from phase 1 if available
        if (daikon.seedsAssignable && userContributions[_daikonId][msg.sender] > 0 && userSeeds[_daikonId][msg.sender] == 0) {
            claimSeeds(_daikonId);
        }

        // Claim seeds from all past periodic sales since the last claim
        for (uint256 i = 0; i < daikon.periodicSaleInfo.currentSaleIndex; i++) {
            if (periodicSaleContributions[_daikonId][i][msg.sender] > 0) {
                claimSeedsFromPastSale(_daikonId, i);
            }
        }
    }
}
