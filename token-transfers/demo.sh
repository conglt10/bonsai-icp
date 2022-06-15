#!/usr/bin/env bash
dfx stop
set -e
trap 'dfx stop' EXIT

# kill dfx
# killall dfx replica nodemanager

# Install Ledger Canister
# export IC_VERSION=a7058d009494bea7e1d898a3dd7b525922979039
# curl -o ledger.wasm.gz https://download.dfinity.systems/ic/$IC_VERSION/canisters/ledger-canister_notify-method.wasm.gz
# gunzip ledger.wasm.gz
# curl -o ledger.private.did https://raw.githubusercontent.com/dfinity/ic/$IC_VERSION/rs/rosetta-api/ledger.did
# curl -o ledger.public.did https://raw.githubusercontent.com/dfinity/ic/$IC_VERSION/rs/rosetta-api/ledger_canister/ledger.did

rm -rf dfx.json
cp private.json dfx.json

dfx start --background

dfx identity new minter || echo "Already have minter"

dfx identity use minter
export MINT_ACC=$(dfx ledger account-id)

dfx identity use default
export LEDGER_ACC=$(dfx ledger account-id)

dfx deploy ledger --argument '(record {minting_account = "'${MINT_ACC}'"; initial_values = vec { record { "'${LEDGER_ACC}'"; record { e8s=100_000_000_000 } }; }; send_whitelist = vec {}})'

rm -rf dfx.json
cp public.json dfx.json

dfx canister call ledger account_balance '(record { account = '$(python3 -c 'print("vec{" + ";".join([str(b) for b in bytes.fromhex("'$LEDGER_ACC'")]) + "}")')' })'


# Transfer token

# dfx identity new your || echo "Already have your"
# dfx identity use your
export YOUR_ACCOUNT_ID_HEX=$(dfx ledger account-id)
read -r -d '' ARGS <<EOM
(record {
     minting_account="${MINT_ACC}";
     initial_values=vec { record { "${YOUR_ACCOUNT_ID_HEX}"; record { e8s=10_000_000_000 } }; };
     send_whitelist=vec {};
 }, )
EOM

dfx deploy --argument "${ARGS}" ledger


LEDGER_ID="$(dfx canister id ledger)"
read -r -d '' ARGS <<EOM
(record {
  ledger_canister_id=principal "${LEDGER_ID}";
  transaction_fee=record { e8s=10_000 };
  subaccount=null
}, )
EOM

dfx deploy --argument "${ARGS}" tokens_transfer


TOKENS_TRANSFER_ACCOUNT_ID="$(dfx ledger account-id --of-canister tokens_transfer)"
TOKENS_TRANSFER_ACCOUNT_ID_BYTES="$(python3 -c 'print("vec{" + ";".join([str(b) for b in bytes.fromhex("'$TOKENS_TRANSFER_ACCOUNT_ID'")]) + "}")')" 
read -r -d '' ARGS <<EOM
(record {
  to=${TOKENS_TRANSFER_ACCOUNT_ID_BYTES};
  amount=record { e8s=100_000 };
  fee=record { e8s=10_000 };
  memo=0:nat64;
}, )
EOM

dfx canister call ledger transfer "${ARGS}"
dfx canister call ledger transfer "${ARGS}"

echo "transfer some of the tokens from the Tokens Transfer canister back to the original account"

export YOUR_PRINCIPAL=$(dfx identity get-principal)
read -r -d '' ARGS <<EOM
(record {
  amount=record { e8s=5 };
  to_principal=principal "${YOUR_PRINCIPAL}"
},)
EOM

dfx canister call tokens_transfer transfer "${ARGS}"
