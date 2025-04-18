// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract GameItems is ERC1155 {
    uint256 public constant SWORD = 1;
    uint256 public constant SHIELD = 2;

    constructor() ERC1155("https://game.example/api/item/{id}.json") {
        _mint(msg.sender, SWORD, 100, "");
        _mint(msg.sender, SHIELD, 50, "");
    }

    function mintItem(address to, uint256 id, uint256 amount) external {
        _mint(to, id, amount, "");
    }
}
