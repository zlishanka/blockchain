import json
import os

from dotenv import load_dotenv
from solcx import compile_standard, install_solc
from web3 import Web3 

load_dotenv()

with open("./SimpleStorage.sol", "r") as file:
    simple_storage_file = file.read()

install_solc("0.6.0")

compiled_sol = compile_standard(
    {
        "language" : "Solidity",
        "sources" : {"SimpleStorage.sol" : {"content" : simple_storage_file}},
        "settings": {
            "outputSelection" : {
                "*" : {"*": ["abi", "metadata", "evm.bytecode", "evm.sourceMap"]}
            }
        },
    },
    solc_version="0.6.0",
)

with open("compiled_code.json", "w") as file:
    json.dump(compiled_sol, file)

# get bytecodes
bytecode = compiled_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"]["evm"]["bytecode"]["object"]
# get abi
abi = compiled_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"]["abi"]

# for connecting to ganache
w3 = Web3(Web3.HTTPProvider("http://127.0.0.1:8545"))
chain_id = 1337
my_address = "0x90F8bf6A479f320ead074411a4B0e7944Ea8c9C1"
private_key = os.getenv("PRIVATE_KEY")

# Create the contract in python
SimpleStorage = w3.eth.contract(abi=abi, bytecode=bytecode)

# Get the latest transaction
nonce = w3.eth.get_transaction_count(my_address)
print(f"nonce={nonce}")
# 1. Build a transaction
# 2. Sign a transaction
# 3. Send a transaction
transaction = SimpleStorage.constructor().build_transaction(
    {"chainId": chain_id, 
     "gasPrice": w3.eth.gas_price, 
     "from": my_address, 
     "nonce": nonce})

signed_txn = w3.eth.account.sign_transaction(transaction, private_key=private_key)
print("Deploying contract...")
tx_hash = w3.eth.send_raw_transaction(signed_txn.rawTransaction)
tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
print("Deployed!")
# working with the cotract, you always need
# contract address
# contract ABI
simple_storage = w3.eth.contract(address=tx_receipt.contractAddress, abi=abi)
# Interact with transaction
# Call -> simulate makeing the call and getting a return value (no change on blockchain)
# Transact -> actually make a state change

# initial value of favorite number
print(simple_storage.functions.retrieve().call())
# print(simple_storage.functions.store(15).call())
# print(simple_storage.functions.retrieve().call())
print("Updating contract...")
store_transaction = simple_storage.functions.store(15).build_transaction({
    "chainId" : chain_id,  
    "gasPrice": w3.eth.gas_price, 
    "from": my_address, 
    "nonce": nonce+1
})
signed_store_txn = w3.eth.account.sign_transaction(
    store_transaction, private_key=private_key
)
send_store_tx = w3.eth.send_raw_transaction(signed_store_txn.rawTransaction)
tx_receipt = w3.eth.wait_for_transaction_receipt(send_store_tx)
print("Updated!")
print(simple_storage.functions.retrieve().call())