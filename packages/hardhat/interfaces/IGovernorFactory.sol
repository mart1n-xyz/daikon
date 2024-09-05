// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

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
