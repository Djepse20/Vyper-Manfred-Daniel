from brownie import *

p = project.load('./', name="yieldfarm")
p.load_config()

from brownie.project.YieldfarmProject import YieldFarm
network.disconnect()
network.connect('development')
def main():
    YieldFarm.deploy(10**27,{'from':accounts[0]})