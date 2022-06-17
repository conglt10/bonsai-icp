<h1  align="center">Bonsai ICP 👋</h1>

![Bonsai-ICP](https://user-images.githubusercontent.com/53574829/173724193-263f6840-a10d-4e81-9539-e87cfaa69f1c.png)

## Bonsai ICP Dapp

This demonstrates the three important parts of a dapp and how they should be connected:

1. The browser UI (ReactJS + Redux)
2. Canister (Rust)

## Functionality

Bonsai ICP :

1. Buy plants from stock by ICP
2. Planting trees in the collection.
3. Transfer bonsai to other account.

Future Function:

1. Each Bonsai is growed from a seed (generate random from Verifiable Random Numbers). The seed determines the quality of the plant as well as other parameters such as growth rate and price (Legendary Bonsai or Normal Bonsai).

2. The canister has the ability to update properties such as the life of a plant, which will display other forms of the plant such as sprouting, flowering, and fruiting.

![growing](https://user-images.githubusercontent.com/52224456/92190568-b43d4300-ee8b-11ea-8699-3ce18938ed26.png)

3. It is possible to resell the trees you have planted.

4. Marketplace NFT for Bonsai

## Video Demo

https://youtu.be/ETJx_K7izMU

## How to run project

```bash
cd ui
cp .env.example .env
yarn install
```

Add infor into `.env`

```bash
yarn start
```

View in http://localhost:3000
