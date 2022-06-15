#!/usr/bin/env bash
dfx stop
set -e
trap 'dfx stop' EXIT

dfx start --background --clean
dfx deploy bonsaicp --no-wallet --argument 'record{name="DFX Blobs";symbol="DFXB";custodians=null;logo=null}'
dfx identity new alice || true
dfx identity new bob || true
YOU=$(dfx identity get-principal)
ALICE=$(dfx --identity alice identity get-principal)
BOB=$(dfx --identity bob identity get-principal)
echo '(*) Creating NFT with metadata "hello":'
dfx canister call bonsaicp mintDip721 \
    "(principal\"$YOU\",vec{record{
        purpose=variant{Rendered};
        data=blob\"hello\";
        key_val_data=vec{
            record{
                \"contentType\";
                variant{TextContent=\"text/plain\"};
            };
            record{
                \"locationType\";
                variant{Nat8Content=4:nat8}
            };
        }
    }},blob\"hello\")"
echo '(*) Metadata of the newly created NFT:'
dfx canister call bonsaicp getMetadataDip721 '(0:nat64)'
echo "(*) Owner of NFT 0 (you are $YOU):"
dfx canister call bonsaicp ownerOfDip721 '(0:nat64)'
echo '(*) Number of NFTs you own:'
dfx canister call bonsaicp balanceOfDip721 "(principal\"$YOU\")"
echo '(*) Number of NFTs Alice owns:'
dfx canister call bonsaicp balanceOfDip721 "(principal\"$ALICE\")"
echo '(*) Total NFTs in existence:'
dfx canister call bonsaicp totalSupplyDip721
echo '(*) Transferring the NFT from you to Alice:'
dfx canister call bonsaicp transferFromDip721 "(principal\"$YOU\",principal\"$ALICE\",0:nat64)"
echo "(*) Owner of NFT 0 (Alice is $ALICE):"
dfx canister call bonsaicp ownerOfDip721 '(0:nat64)'
echo '(*) Number of NFTs you own:'
dfx canister call bonsaicp balanceOfDip721 "(principal\"$YOU\")"
echo '(*) Number of NFTs Alice owns:'
dfx canister call bonsaicp balanceOfDip721 "(principal\"$ALICE\")"
echo '(*) Alice approves Bob to transfer NFT 0 for her:'
dfx --identity alice canister call bonsaicp approveDip721 "(principal\"$BOB\",0:nat64)"
echo '(*) Bob transfers NFT 0 to himself:'
dfx --identity bob canister call bonsaicp transferFromDip721 "(principal\"$ALICE\",principal\"$BOB\",0:nat64)"
echo "(*) Owner of NFT 0 (Bob is $BOB):"
dfx canister call bonsaicp ownerOfDip721 '(0:nat64)'
echo '(*) Bob approves Alice to operate on any of his NFTs:'
dfx --identity bob canister call bonsaicp setApprovalForAllDip721 "(principal\"$ALICE\",true)"
echo '(*) Alice transfers 0 to herself:'
dfx --identity alice canister call bonsaicp transferFromDip721 "(principal\"$BOB\",principal\"$ALICE\",0:nat64)"
echo '(*) You are a custodian, so you can transfer the NFT back to yourself without approval:'
dfx canister call bonsaicp transferFromDip721 "(principal\"$ALICE\",principal\"$YOU\",0:nat64)"

dfx identity remove alice
dfx identity remove bob
