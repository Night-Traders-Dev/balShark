# balShark

**balShark** is a lightweight tool for generating and scanning cryptocurrency addresses across Ethereum, Base, Polygon, and Binance Smart Chain (BSC) networks. It checks the balance of each generated address using respective blockchain APIs.

## Features

- Automatically generates random BIP-39 seed phrases and derives corresponding public/private keys.
- Scans balances for Ethereum (ETH), Base (ETH), Polygon (MATIC), and Binance Smart Chain (BNB) using their respective APIs.
- Logs addresses with non-zero balances to a text file (`keys.txt`).
- Ensures API call responsiveness with a 5-second timeout on each request.

## Prerequisites

To run balShark, you need the following:

- **Bash** (for running the main script).
- **Python 3** (for generating the BIP-39 seed phrase).
- The following Python libraries:
  - `bip_utils` (for BIP-39 seed generation).
  - `jq` (for JSON parsing in the Bash script).
  - `bc` (for floating-point arithmetic in Bash).

### Python Libraries Installation

Install the required Python library via pip:

```bash
pip install bip_utils
```
Tools Installation (if not already installed):

jq (JSON parsing tool for Bash):

```bash
sudo apt-get install jq
```
bc (calculator for Bash):

```bash
sudo apt-get install bc
```
Setup

1. Clone the Repository
```bash
git clone https://github.com/NightTradersDev/balshark.git
cd balshark
```
2. Set Up API Keys

You need API keys for Etherscan, Polygonscan, Basescan, and BSCScan. Get the keys from their respective websites:

Etherscan API

Polygonscan API

Basescan API

BSCScan API


Once you have the API keys, update the values in balShark.sh:
```bash
ETHERSCAN_API_KEY="your_etherscan_api_key"
BASESCAN_API_KEY="your_basescan_api_key"
POLYGONSCAN_API_KEY="your_polygonscan_api_key"
BSCSCAN_API_KEY="your_bscscan_api_key"
```
3. Make the Scripts Executable

Ensure the Bash script has execution permissions:
```bash
chmod +x balShark.sh
```
Usage

1. Run the script by executing the following command:


```bash
./balShark.sh
```
The script will continuously generate new BIP-39 seed phrases and public/private key pairs, and check their balances across the Ethereum, Base, Polygon, and Binance Smart Chain networks.

2. Output:



The script will display the balance for each address it checks.

If an address with a non-zero balance is found, the address and its private key will be saved to keys.txt for later review.


Sample Output:
```bash
---------------------------------------------------------------
***balShark...Scan Complete***

Ethereum Mainnet Balance: 0.00032 ETH
Polygon Mainnet Balance: 0.00001 MATIC

Key:
0xABCD1234...

Address:
0x123456789...

Addresses Scanned: 42
Found Addresses: 2
Elapsed Time: 0 hours, 12 minutes, 35 seconds
---------------------------------------------------------------
```
Python Script Details (bip39.py)

The Python script is responsible for generating a random 12-word BIP-39 seed phrase and deriving the corresponding private and public keys.

Example code for bip39.py:
```python
from bip_utils import Bip39MnemonicGenerator, Bip39SeedGenerator, Bip44, Bip44Coins, Bip44Changes

# Generate a random 12-word BIP-39 mnemonic phrase
mnemonic = Bip39MnemonicGenerator().FromWordsNumber(12)
seed = Bip39SeedGenerator(mnemonic).Generate()

# Derive key pair using BIP-44 (Ethereum in this case)
bip44 = Bip44.FromSeed(seed, Bip44Coins.ETHEREUM)
account = bip44.Purpose().Coin().Account(0).Change(Bip44Changes.CHAIN_EXT).AddressIndex(0)
private_key = account.PrivateKey().Raw().ToHex()
public_address = account.PublicKey().ToAddress()

# Output private key and public address
print(private_key, public_address)
```
Running the Python Script Independently

You can run bip39.py independently to generate a new BIP-39 mnemonic and keys:
```bash
python3 bip39.py
```
It will output the private key and corresponding public address, which can then be used for manual balance checks or other purposes.

License

This project is licensed under the MIT License.

Acknowledgments

bip_utils for making the BIP-39 generation process straightforward.

jq for JSON parsing in Bash.


You can copy this block as it is formatted for Markdown usage in a `README.md` file.

