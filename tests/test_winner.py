from brownie import HardcoreGamble, accounts
from web3 import Web3
ether = 1000000000000000000
def test_highball_win():
    account = accounts[0]
    account1 = accounts[1]
    account2 = accounts[2]
    account3 = accounts[3]
    dep = HardcoreGamble.deploy({"from":account})
    dep.enterPool({"from":account,"value": 0.1*ether  })
    dep.enterPool({"from":account1,"value": 0.2*ether  })
    dep.enterPool({"from":account2,"value": 0.7*ether })
    dep.enterPool({"from":account3,"value": 0.6*ether })
    assert dep.getWinner() == account2
    assert dep.getNumberOfParticipants() == 4
    assert dep.getPool() == 1.6*ether
    
def test_lowball_win():
    account = accounts[0]
    account1 = accounts[1]
    account2 = accounts[2]
    account3 = accounts[3]
    dep = HardcoreGamble.deploy({"from":account})
    dep.enterPool({"from":account,"value": 0.3*ether  })
    dep.enterPool({"from":account1,"value": 0.2*ether  })
    dep.enterPool({"from":account2,"value": 0.4*ether })
    dep.enterPool({"from":account3,"value": 0.3*ether })
    assert dep.getWinner() == account2
    assert dep.getNumberOfParticipants() == 4
    assert dep.getPool() == 1.2*ether
   
def test_highball_not_finished():
    account = accounts[0]
    account1 = accounts[1]
    account2 = accounts[2]
    account3 = accounts[3]
    dep = HardcoreGamble.deploy({"from":account})
    dep.enterPool({"from":account,"value": 0.1*ether  })
    dep.enterPool({"from":account1,"value": 0.2*ether  })
    dep.enterPool({"from":account2,"value": 1.8*ether })
    dep.enterPool({"from":account3,"value": 0.4*ether })
    assert dep.getWinner() == '0x0000000000000000000000000000000000000000'
    assert dep.getNumberOfParticipants() == 4
    assert dep.getPool() == 2.5*ether
   
def test_lowball_not_finished():
    account = accounts[0]
    account1 = accounts[1]
    account2 = accounts[2]
    account3 = accounts[3]
    dep = HardcoreGamble.deploy({"from":account})
    dep.enterPool({"from":account,"value": 0.4*ether })
    dep.enterPool({"from":account1,"value": 0.4*ether  })
    dep.enterPool({"from":account2,"value": 0.6*ether })
    dep.enterPool({"from":account3,"value": 0.1*ether })
    assert dep.getWinner() == '0x0000000000000000000000000000000000000000'
    assert dep.getNumberOfParticipants() == 4
    assert dep.getPool() == 1.5*ether

def test_long_unfinished_game():
    account = accounts[0]
    account1 = accounts[1]
    account2 = accounts[2]
    account3 = accounts[3]
    account4 = accounts[4]
    account5 = accounts[5]
    account6 = accounts[6]
    account7 = accounts[7]
    dep = HardcoreGamble.deploy({"from":account})
    dep.enterPool({"from":account,"value": 0.01*ether  })
    dep.enterPool({"from":account1,"value": 0.01*ether  })
    dep.enterPool({"from":account2,"value": 0.01*ether })
    dep.enterPool({"from":account3,"value": 0.02*ether })
    dep.enterPool({"from":account4,"value": 0.03*ether  })
    dep.enterPool({"from":account5,"value": 0.04*ether })
    dep.enterPool({"from":account6,"value": 0.05*ether })
    dep.enterPool({"from":account7,"value": 0.02*ether })
    assert dep.getWinner() == '0x0000000000000000000000000000000000000000'
    assert dep.getNumberOfParticipants() == 8
    assert dep.getPool() == 0.19*ether