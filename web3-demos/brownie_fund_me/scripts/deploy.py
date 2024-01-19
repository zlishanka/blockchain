from scripts.helpful_scripts import get_account
from brownie import FundMe

import os

def depoly_fund_me():
    account = get_account()
    fund_me = FundMe.deploy("0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e", {"from": account})
    # fund_me = FundMe.deploy({"from": account}, publish_source=True,)
    print(f"contract deployed to {fund_me.address}")
  
def main():
    depoly_fund_me()