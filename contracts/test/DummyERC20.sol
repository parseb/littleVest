// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.11;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract MockERC20 is ERC20("MockeyTockey", "MTOK") {

    constructor() {
        _mint(msg.sender, type(uint256).max - 1); 
    }
}