// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// A token lock contract that releases tokens after a specific time
contract TokenTimelock {
    IERC20 public token;
    address public beneficiary;
    uint256 public releaseTime;

    constructor(IERC20 _token, address _beneficiary, uint256 _releaseTime) {
        require(_releaseTime > block.timestamp, "Release time is in the past");
        token = _token;
        beneficiary = _beneficiary;
        releaseTime = _releaseTime;
    }

    // Releases tokens after the lock time has passed
    function release() public {
        require(block.timestamp >= releaseTime, "Too early to release");
        uint256 amount = token.balanceOf(address(this));
        require(amount > 0, "No tokens to release");
        token.transfer(beneficiary, amount);
    }
}
