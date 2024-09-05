// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IVotes} from "@openzeppelin/contracts/governance/utils/IVotes.sol";
import {TimelockController} from "@openzeppelin/contracts/governance/TimelockController.sol";

interface IGovernorFactory {
    function graduationCeremony() external view returns (address);
    
    function setGraduationCeremony(address _graduationCeremony) external;

    function deployGovernor(
        string memory name,
        IVotes token,
        TimelockController timelock
    ) external returns (address);
}
