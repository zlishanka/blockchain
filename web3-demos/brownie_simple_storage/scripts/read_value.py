from brownie import SimpleStorage

def read_contract():
    simple_storage = SimpleStorage[-1] # latest deployed 
    # ABI
    # Address
    print(simple_storage.retrieve())


def main():
    read_contract()