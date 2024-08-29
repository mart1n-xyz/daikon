//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

// Useful for debugging. Remove when deploying to a live network.
import "hardhat/console.sol";

import "@openzeppelin/contracts/access/Ownable.sol";


contract DaikonFactory is Ownable {

	
	/**
	 * Function that allows the contract to receive ETH
	 */
	receive() external payable {}
}
