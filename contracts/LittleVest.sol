// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.11;

/// @title LittleVest
/// @author parseb | @parseb | petra306@protonmail.com
/// @custom:security contact: petra306@protonmail.com

import 'parseb/vest_minimal@0.0.1-alpha/src/MiniVest.sol';
import '@openzeppelin/contracts/token/ERC721/ERC721.sol';


contract LittleVest is MiniVest(999999999999999999 * 10 **18), ERC721("LittleVest", "VEST") {

    /// @notice nft id to retunrn [Token, Beneficiarry] for vesting[][] 
    mapping(uint256 => address[2]) public idTBVest;
    uint256 tId = 1;

    function setVest(address _token, 
                    address _beneficiary, 
                    uint256 _amount, 
                    uint256 _days) 
                    external
                    override 
                    returns (bool s) {
                        s = super.setVest(_token, _beneficiary, _amount, _days);
                        require(s);
                        idTBVest[tokenId]= [_token, to];
                        _mint(tId);
                        unchecked { tId++; }
                    }


    ///// Override ERC721 Hooks
    ///@todo ....
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override {
    
        if (from != address(0)) {
            vestings[idTBvest[tokenId][0]][from] = 0;
            idTBVest[tokenId]= [idTBVest[tokenId][0], to];
        } 
    }

    function _afterTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override {
        vestings[idTBVest[tokenId][0]][idTBVest[tokenId][1]] = vestings[idTBVest[tokenId][0]][from];
    }


} 