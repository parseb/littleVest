from unittest import mock
import pytest
from tests.conftest import LittleV, mock20_0, mock20_1, mock20_1
from brownie import chain, accounts, ZERO_ADDRESS, reverts


def test_assume_check(LittleV, mock20_0, mock20_1):
    assert LittleV.balanceOf(accounts[0]) == 0
    assert LittleV.balanceOf(accounts[1]) == 0
    with reverts():
        assert LittleV.balanceOf(ZERO_ADDRESS) == 0
    assert mock20_0.balanceOf(accounts[0]) > 0
    assert mock20_0.balanceOf(accounts[1]) == 0
    assert mock20_1.balanceOf(accounts[0]) == 0
    assert mock20_1.balanceOf(accounts[1]) > 0

def test_happy_path(LittleV, mock20_0, mock20_1):
    a0 = {"from": accounts[0]}
    a1 = {"from": accounts[1]}
    a2 = {"from": accounts[2]}
    a3 = {"from": accounts[3]}

    a0_LV_balance = LittleV.balanceOf(accounts[0], a0)
    a1_LV_balance = LittleV.balanceOf(accounts[1], a1)

    assert a0_LV_balance == a1_LV_balance == 0
    mock20_0.approve(LittleV.address, mock20_0.balanceOf(accounts[0]), a0)
    mock20_1.approve(LittleV.address, mock20_1.balanceOf(accounts[1]), a1)

    s0 = LittleV.setVest(mock20_0.address, accounts[2].address, 100, 200, a0).return_value
    s1 = LittleV.setVest(mock20_1.address, accounts[3].address, 100, 200, a1).return_value

    chain.mine(1)
    assert s0 == s1 == True

    b0_LV_balance = LittleV.balanceOf(accounts[0], a0)
    b1_LV_balance = LittleV.balanceOf(accounts[1], a1)

    b0_LV_balance == b1_LV_balance == 1

    assert LittleV.ownerOf(1) != accounts[0].address
    assert LittleV.ownerOf(1) == accounts[2].address

    assert LittleV.ownerOf(2) != accounts[1].address
    assert LittleV.ownerOf(2) == accounts[3].address

    with reverts():
        LittleV.setVest(mock20_0.address, accounts[2].address, 100, 200, a0).return_value

    mock20_1.transfer(accounts[0], 300 * 10 **18, a1)
    mock20_1.approve(LittleV.address, 99999*10**18, a0)

    # token, beneficiary, ammount, days, sender
    assert LittleV.setVest(mock20_1.address, accounts[2].address, 100, 200, a0).return_value

    with reverts():
        LittleV.setVest(mock20_1.address, accounts[3].address, 100, 200, a1).return_value

    mock20_0.transfer(accounts[1], 300 * 10 **18, a0)
    mock20_0.approve(LittleV.address, 99999*10**18, a1)

    assert LittleV.setVest(mock20_0.address, accounts[3].address, 100, 200, a1).return_value

    with reverts():
        LittleV.withdrawAvailable(mock20_0.address, a1)

    with reverts():
        LittleV.withdrawAvailable(mock20_1.address, a0)

    chain.mine(256)

    # partial withdraw
    chain.sleep(100 * 86400)
    partial2 = LittleV.getVest(mock20_0.address, accounts[2].address)
    assert partial2 > 999 * 10 ** 18
    assert LittleV.withdrawAvailable(mock20_0.address, a2).return_value == True
    withdrawn1 = LittleV.getVest(mock20_0.address, accounts[2].address)
    assert partial2 > withdrawn1

    # witdraw rest
    chain.sleep(100 * 86400)
    chain.mine(1)

    assert LittleV.withdrawAvailable(mock20_0.address, a2).return_value == True
    withdrawn1 = LittleV.getVest(mock20_0.address, accounts[2].address)
    assert partial2 > withdrawn1
    assert withdrawn1 == 0

    
    #### no partial withdrawal

    partial2 = LittleV.getVest(mock20_1.address, accounts[3].address)
    assert partial2 > 999 * 10 ** 18
    assert LittleV.withdrawAvailable(mock20_1.address, a3).return_value == True
    assert LittleV.balanceOf(accounts[3].address, a1) == 1
    withdrawn1 = LittleV.getVest(mock20_1.address, accounts[3].address)
    
    assert partial2 > withdrawn1
    assert withdrawn1 == 0


    ### test nft transfer withdrawal

    # create vest
    assert LittleV.setVest(mock20_1.address, accounts[2].address, 100, 200, a0).return_value
    #transfer nft

    # receiver claims vest

    # burn nft on full witdrawal.. override withdrawAvailable
