from brownie import LittleVest, accounts, MockERC20


def main():
    acct = accounts[0]
    deployed1 = LittleVest.deploy({'from': acct})
    print("LittleVest deplyed at: ", deployed1.address)
    deployed2 = MockERC20.deploy({'from': acct})
    print("MockERC20 deplyed at: ", deployed2.address)
