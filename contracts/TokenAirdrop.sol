// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TokenAirdrop {
    IERC20 public token;

    constructor(IERC20 _token) {
        token = _token;
    }

    function airdrop(address[] calldata recipients, uint256 amount) external {
        for (uint256 i = 0; i < recipients.length; i++) {
            token.transferFrom(msg.sender, recipients[i], amount);
        }
    }
}
