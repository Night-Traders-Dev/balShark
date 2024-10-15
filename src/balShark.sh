#!/bin/bash
clear
echo -e "***loading balShark...***\nSupports Ethereum, Base, Polygon, and BSC\n\n***"

ETHERSCAN_API_KEY=""
BASESCAN_API_KEY=""
POLYGONSCAN_API_KEY=""
BSCSCAN_API_KEY=""

address_count=0
found_count=0
start_time=$(date +%s)

while true; do
    read private_key public_address < <(python3 ./bip39.py)

    clear
    echo -e "---------------------------------------------------------------"
    echo -e "***balShark...Scanning APIs***\n\n\n\n\n\n\n\n\n\n"
    echo -e "Key:\n$private_key\n\nAddress:\n$public_address\n"
    echo -e "Addresses Scanned:\n$address_count\n"
    echo -e "Found Addresses:\n$found_count\n"
    echo -e "Elapsed Time:\n$elapsed_hours hours, $elapsed_minutes minutes, $elapsed_seconds seconds\n"
    echo -e "---------------------------------------------------------------\n\n"

    # Fetch balance from Etherscan (Ethereum Mainnet) with a 5-second timeout
    eth_response=$(curl -s --max-time 5 "https://api.etherscan.io/api?module=account&action=balance&address=$public_address&tag=latest&apikey=$ETHERSCAN_API_KEY")
    eth_balance=$(echo "$eth_response" | jq -r '.result')
    if [[ "$eth_balance" =~ ^[0-9]+$ ]]; then
        eth_balance_in_ether=$(echo "scale=18; $eth_balance / 1000000000000000000" | bc -l)
    else
        eth_balance_in_ether="API call failed"
    fi

    # Fetch balance from Polygonscan (Polygon Mainnet) with a 5-second timeout
    polygon_response=$(curl -s --max-time 5 "https://api.polygonscan.com/api?module=account&action=balance&address=$public_address&tag=latest&apikey=$POLYGONSCAN_API_KEY")
    polygon_balance=$(echo "$polygon_response" | jq -r '.result')
    if [[ "$polygon_balance" =~ ^[0-9]+$ ]]; then
        polygon_balance_in_matic=$(echo "scale=18; $polygon_balance / 1000000000000000000" | bc -l)
    else
        polygon_balance_in_matic="API call failed"
    fi

    # Fetch balance from Basescan (Base Mainnet) with a 5-second timeout
    base_response=$(curl -s --max-time 5 "https://api.basescan.org/api?module=account&action=balance&address=$public_address&tag=latest&apikey=$BASESCAN_API_KEY")
    base_balance=$(echo "$base_response" | jq -r '.result')
    if [[ "$base_balance" =~ ^[0-9]+$ ]]; then
        base_balance_in_eth=$(echo "scale=18; $base_balance / 1000000000000000000" | bc -l)
    else
        base_balance_in_eth="API call failed"
    fi

    # Fetch balance from BSCScan (Binance Smart Chain) with a 5-second timeout
    bsc_response=$(curl -s --max-time 5 "https://api.bscscan.com/api?module=account&action=balance&address=$public_address&tag=latest&apikey=$BSCSCAN_API_KEY")
    bsc_balance=$(echo "$bsc_response" | jq -r '.result')
    if [[ "$bsc_balance" =~ ^[0-9]+$ ]]; then
        bsc_balance_in_bnb=$(echo "scale=18; $bsc_balance / 1000000000000000000" | bc -l)
    else
        bsc_balance_in_bnb="API call failed"
    fi

    address_count=$((address_count + 1))
    current_time=$(date +%s)
    elapsed_time=$((current_time - start_time))
    elapsed_hours=$((elapsed_time / 3600))
    elapsed_minutes=$(((elapsed_time % 3600) / 60))
    elapsed_seconds=$((elapsed_time % 60))

    clear
    echo -e "---------------------------------------------------------------"
    echo -e "***balShark...Scan Complete***\n"
    if [[ "$eth_balance_in_ether" != "API call failed" ]]; then
        echo -e "\nEthereum Mainnet Balance: $eth_balance_in_ether ETH\n"
    fi
    if [[ "$base_balance_in_eth" != "API call failed" ]]; then
        echo -e "Base Mainnet Balance: $base_balance_in_eth ETH\n"
    fi
    if [[ "$polygon_balance_in_matic" != "API call failed" ]]; then
        echo -e "Polygon Mainnet Balance: $polygon_balance_in_matic MATIC\n"
    fi
    if [[ "$bsc_balance_in_bnb" != "API call failed" ]]; then
        echo -e "Binance Smart Chain Balance: $bsc_balance_in_bnb BNB\n"
    fi
    echo -e "Key:\n$private_key\n\nAddress:\n$public_address\n"
    echo -e "Addresses Scanned:\n$address_count\n"
    echo -e "Found Addresses:\n$found_count\n"
    echo -e "Elapsed Time:\n$elapsed_hours hours, $elapsed_minutes minutes, $elapsed_seconds seconds\n"
    echo -e "---------------------------------------------------------------\n\n"

    if (( $(echo "$eth_balance_in_ether > 0" | bc -l) )) || \
       (( $(echo "$base_balance_in_eth > 0" | bc -l) )) || \
       (( $(echo "$polygon_balance_in_matic > 0" | bc -l) )) || \
       (( $(echo "$bsc_balance_in_bnb > 0" | bc -l) )); then
        found_count=$((found_count + 1))
        echo -e "Address: $public_address\nKey: $private_key\n\n" >> keys.txt
    fi
done
