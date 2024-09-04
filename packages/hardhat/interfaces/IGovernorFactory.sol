pragma solidity >=0.8.0 <0.9.0;

import {IVotes} from "../artifacts/@openzeppelin/contracts/governance/utils/IVotes.sol";
import {TimelockController} from "../artifacts/@openzeppelin/contracts/governance/TimelockController.sol";

interface IGovernorFactory {
    function graduationCeremony() external view returns (address);
    
    function deployGovernor(
        string memory name,
        IVotes token,
        TimelockController timelock
    ) external returns (address);
}
