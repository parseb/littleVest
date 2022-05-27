from brownie import accounts, LittleVest, MockERC20


def main():
    acct = accounts.load('69')
    deployed1 = LittleVest.deploy({'from': acct})
    print("LittleVest deplyed at: ", deployed1.address)
    deployed2 = MockERC20.deploy({'from': acct})
    print("MockERC20 deplyed at: ", deployed2.address)