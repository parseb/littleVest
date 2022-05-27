from brownie import accounts, LittleVest, MockERC20


def main():
    acct = accounts.load('69')
    deployed1 = LittleVest.deploy({'from': acct}, publish_source=True)
    print("LittleVest deplyed at: ", deployed1.address)
    deployed2 = MockERC20.deploy({'from': acct}, publish_source=True)
    print("MockERC20 deplyed at: ", deployed2.address)
    writetofile = open("deployed_mumbai.txt", "w")
    writetofile.write("LV: " + str(deployed1.address) + "\n" + "ValueConduct: " + str(deployed2))
    writetofile.close()