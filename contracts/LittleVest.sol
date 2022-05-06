// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.11;

/// @title LittleVest
/// @author parseb | @parseb | petra306@protonmail.com
/// @custom:security contact: petra306@protonmail.com

import 'parseb/vest_minimal@0.0.5-alpha/src/MiniVest.sol';
import '@openzeppelin/contracts/token/ERC721/ERC721.sol';

uint256 constant k = 999999999999999999 * 10 **18;


contract LittleVest is ERC721("LittleVest", "VEST"), MiniVest(k) {

    /// @notice nft id to retunrn [Token, Beneficiarry] for vesting[][] 
    mapping(uint256 => address[2]) public idTBVest;
    mapping(address => uint256[]) public userVestsId;
    uint256 tId;

    constructor() { 
        tId = 1;
    }

    

    function setVest(address _token, 
                    address _beneficiary,
                    uint256 _amount, 
                    uint256 _days)
                    public
                    override
                    returns (bool s) {
                        s = super.setVest(_token, _beneficiary, _amount, _days);
                        require(s);
                        idTBVest[tId]= [_token, _beneficiary];
                        _mint(_beneficiary, tId);
                        userVestsId[_beneficiary].push(tId);
                        unchecked { tId++; }
                    }


    /// @dev no override on withdrawAvailable()
      function withdrawAvailable(address _ERC20, uint256 tokenId) public returns (bool s) {
          require(_ERC20 ==  idTBVest[tokenId][0], "wrong ERC20");
          require(msg.sender == idTBVest[tokenId][1], "Unauthorised");
          require(vestings[_ERC20][msg.sender] > 0, "No vesting");

          s = super.withdrawAvailable(_ERC20);
          if (vestings[_ERC20][msg.sender] == 0) { 
               _burn(tokenId);
                delete idTBVest[tokenId];
               }
      }



    ///// Override ERC721 Hooks
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override {
    
        if (from != address(0)) {
            vestings[idTBVest[tokenId][0]][from] = 0;
            idTBVest[tokenId]= [idTBVest[tokenId][0], to];
        } 
    }

    function _afterTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override {
        if (from != address(0)) vestings[idTBVest[tokenId][0]][idTBVest[tokenId][1]] = vestings[idTBVest[tokenId][0]][from];
        //if (to == address(0)) delete idTBVest[tokenId];
    }



    //// View

    function getUserVests(address _user) public view returns(uint256[] memory) {
        return userVestsId[_user];
    }

} 