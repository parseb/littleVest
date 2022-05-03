// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.11;



// import "./test/utils/Console2.sol";
/// @title LogV
/// @author parseb | @parseb | petra306@protonmail.com
/// @notice Optional Logging functionality for vesting contracts
/// @custom:security contact: petra306@protonmail.com

abstract contract LogV {

uint256 public immutable deployedAt;
mapping(address=> mapping(address=> uint256[])) public logStore;
    constructor() {
        deployedAt = block.timestamp;
    }

    /// @dev would makes sense if would use uint256[].push for storage
    function logChange(address _token, address _beneficiary, uint256 _data) internal {
        logStore[_token][_beneficiary].push(_data); 
    }

 }