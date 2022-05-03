// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.11;

import {DSTestPlus} from "./utils/DSTestPlus.sol";
import {MiniVest} from "../MiniVest.sol";
import {MockERC20} from "./utils/MockERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract MiniVestTest is DSTestPlus {
    MiniVest V;
    MockERC20 E;
    address eAddr;
    uint256 oneToken;
    uint256 k;

    function setUp() public {
        k = 999999999999999999 * 10 **18;
        E = new MockERC20();
        V = new MiniVest(k);
        oneToken = 1e18;
        eAddr = address(E);

        E.approve(address(V), type(uint256).max - 1);
    }


    function setupVest(address _beneficiary, uint32 _amt, uint256 _timestampX) public returns (bool) {
        return V.setVest(eAddr, _beneficiary, oneToken * _amt, _timestampX);
    }

    function testSetVest(uint32 _ammount_, address _benefits_) public {
        uint256 endD = 356;
        vm.assume(_ammount_ > endD);
        uint256 ammount = uint256(_ammount_);

        vm.assume(_benefits_ != address(0));
        V.setVest(eAddr, _benefits_, ammount, endD);
        vm.warp(endD * 2 days);
        
        bool s = V.getVest(eAddr, _benefits_) == (ammount* k) + ( endD * 1 days);
        assertTrue(s);
    }

    function testWithdrawAvailable( address _who_, uint32 _amount_, uint8 _timeX_) public {
        vm.assume(_who_ != address(0));
        vm.assume(_amount_ > 1);
        vm.assume(_timeX_ > 1);
        uint256 t = uint256(_timeX_);

        setupVest(_who_, _amount_, t);
        uint256 getsVest = V.getVest(eAddr, _who_);
     
        bool hasVest = getsVest > _amount_ * k;
        assertTrue(hasVest);
        
        (uint256 v1, uint256 who1) = (IERC20(eAddr).balanceOf(address(V)), IERC20(eAddr).balanceOf(_who_));  
        assertTrue(who1 == 0);
        assertTrue(getsVest > _amount_ * k );
        vm.warp(t * 1 days / 2 + block.timestamp);

        vm.prank(_who_);
        assertTrue(V.withdrawAvailable(eAddr));
        assertTrue(IERC20(eAddr).balanceOf(address(V)) >0);


        (uint256 v2, uint256 who2) = (IERC20(eAddr).balanceOf(address(V)), IERC20(eAddr).balanceOf(_who_));

        assertTrue(v1 == v2 + who2);
        assertTrue(getsVest > V.getVest(eAddr, _who_));

        
        assertTrue(V.getVest(eAddr, _who_) > 0 );
        vm.warp(t * 1 days / 3 + block.timestamp);
        assertTrue(V.getVest(eAddr, _who_) > 0 );
        vm.warp(t * 1 days + block.timestamp);
        assertTrue(V.getVest(eAddr, _who_) > 0 );
        vm.prank(_who_);
        assertTrue(V.withdrawAvailable(eAddr));
        //assertTrue(V.getVest(eAddr, _who_) == 0 );

        /// @todo granularity and same block 

    }
    
}
