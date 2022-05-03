// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.0;

interface IMiniVest {
    /// @notice create vesting agreement
    /// @param _token ERC20 token contract address to be vested
    /// @param _beneficiary beneficiary of the vesting agreement
    /// @param _amount amount of tokens to be vested for over period
    /// @param _days durration of vestion period in days
    function setVest(address _token, 
                    address _beneficiary, 
                    uint256 _amount, 
                    uint256 _days) 
                    external 
                    returns (bool s);

    /// @notice withdraws all tokens that have vested for given ERC20 contract address and msg.sender
    /// @param _token ERC20 contract of token to be withdrawn
    function withdrawAvailable(address _token) external returns (uint256);


    /// @notice retrieves vesting data for a given token-beneficiary pair
    /// @param _token ERC20 token contract
    /// @param _beneficiary beneficiary of the vesting agreement
    function getVest(address _token, address _beneficiary) external view returns (uint256);
}
