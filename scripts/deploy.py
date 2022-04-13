from brownie import HardcoreGamble, accounts
ether = 1000000000000000000
def deploy():

    account = accounts[0]
    account1 = accounts[1]
    account2 = accounts[2]
    account3 = accounts[3]
    account4 = accounts[4]

    dep = HardcoreGamble.deploy({"from":account})
    dep.enterPool({"from":account,"value": 0.2*ether  })
    dep.enterPool({"from":account1,"value": 0.2*ether  })
    dep.enterPool({"from":account2,"value": 0.3*ether  })
    print(dep.getWinner())
    dep.enterPool({"from":account3,"value": 0.5*ether  })
    print(dep.getWinner())
    dep.enterPool({"from":account4,"value": 0.4*ether  })
    print(dep.getWinner())
def main():
    deploy()