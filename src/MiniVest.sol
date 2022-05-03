// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.11;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";


/// @title MiniVest
/// @author parseb | @parseb | petra306@protonmail.com
/// @notice Minimalist vesting contract study
/// @dev As expected. Experimental
/// @custom:security contact: petra306@protonmail.com

contract MiniVest is ReentrancyGuard {

    /// @notice storage of vesting agreements  [token][beneficiary] = vesting
    /// @dev getter function  
    mapping(address => mapping(address => uint256[])) public vestings;

    uint256 immutable k; //19
    uint256 immutable oneToken; //1e18

    error VestingInProgress(address, address);

    event NewVesting(address indexed token, address indexed beneficiary, uint256 amt, uint256 bywhen);
    event VestingCompleted(address indexed token, address indexed beneficiary, uint256 amt);
    event WithdrewFromVest(address indexed token, address indexed beneficiary, uint256 partialAmt);

    /// @notice constructor sets immutable constant
    /// @param _k constant for vesting time and ammount encoding in 1 uint256
    constructor(uint256 _k) {
        k = _k;
        oneToken = 1e18;
    }

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
                    returns (bool s) {

        if (vestings[_token][_beneficiary].length != 0) revert VestingInProgress(_token, _beneficiary);
        require(IERC20(_token).balanceOf(msg.sender) >= _amount * oneToken, "Insufficient funds");

        require(_amount * _days > 1, "Amount must be greater than 0");
        require(_beneficiary != address(0), "Beneficiary is 0");
        require(_amount > _days, "Amount must be greater than days");
        require(_amount < k, "Max amount is k-1");

        vestings[_token][_beneficiary].push( _amount * k + ( _days * 1 days + block.timestamp ));

        s = IERC20(_token).transferFrom(msg.sender, address(this), _amount * oneToken);


        emit NewVesting(_token, _beneficiary, _amount, _days);
        return s;
    }


    /// @notice withdraws all tokens that have vested for given ERC20 contract address and msg.sender
    /// @param _token ERC20 contract of token to be withdrawn
    function withdrawAvailable(address _token) external nonReentrant returns (bool s) {
        require(vestings[_token][msg.sender].length > 0, "Nothing to bag");
        uint256 iv= vestings[_token][msg.sender][vestings[_token][msg.sender].length - 1];

        if (iv % k < block.timestamp) {
            delete vestings[_token][msg.sender];
            s = IERC20(_token).transfer(msg.sender, (iv/k) * oneToken);
            require(s, "Transfer failed");

            emit VestingCompleted(_token, msg.sender, iv/k);

        } else {

            uint256 eligibleAmount = (iv / k) - ( ((iv / k) / (iv % k)) * ( (iv % k) - block.timestamp ) );
            vestings[_token][msg.sender].push((iv / k - eligibleAmount) * k + ((iv % k) - ((iv % k) - block.timestamp) ));

            s = IERC20(_token).transfer(msg.sender, eligibleAmount * oneToken);
            require(s, "Transfer failed");

            emit WithdrewFromVest(_token, msg.sender, eligibleAmount);
        }
    }

    /// @notice retrieves vesting data for a given token-beneficiary pair
    /// @param _token ERC20 token contract
    /// @param _beneficiary beneficiary of the vesting agreement 
    function getVest(address _token, address _beneficiary) external view returns ( uint256  ) {
        return vestings[_token][_beneficiary][vestings[_token][_beneficiary].length - 1] ;
    }
}
