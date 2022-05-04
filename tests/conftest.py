import pytest
from brownie import accounts, LittleVest, chain, ZERO_ADDRESS, MockERC20 



@pytest.fixture
def LittleV():
    deployed1 = LittleVest.deploy({'from': accounts[0]})
    return deployed1

@pytest.fixture
def mock20_0():
    deployed2 = MockERC20.deploy({'from': accounts[0]})
    print("MockERC20/0 deplyed at: ", deployed2.address)
    return deployed2

@pytest.fixture
def mock20_1():
    deployed2 = MockERC20.deploy({'from': accounts[1]})
    print("MockERC20/1 deplyed at: ", deployed2.address)
    return deployed2
