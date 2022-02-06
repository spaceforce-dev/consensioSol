
This indicator is based on Consensio Trading System by Tyler Jenks.
What is Relativity?
According to this trading system, you start by laying 3 Simple Moving Averages:
A Long-Term Moving Average (LTMA).
A Short-Term Moving Average (STMA).
A Price Moving Average (Price).
*The "Price" should be A relatively short Moving Average in order to reflect the current price.
When laying out those 3 Moving averages on top of each other, you discover 13 unique types of relationships:
Relativity A: Price > STMA, Price > LTMA, STMA > LTMA
Relativity B: Price = STMA, Price > LTMA, STMA > LTMA
Relativity C: Price < STMA, Price > LTMA, STMA > LTMA
Relativity D: Price < STMA, Price = LTMA, STMA > LTMA
Relativity E: Price < STMA, Price < LTMA, STMA > LTMA
Relativity F: Price < STMA, Price < LTMA, STMA = LTMA
Relativity G: Price < STMA, Price < LTMA, STMA < LTMA
Relativity H: Price = STMA, Price < LTMA, STMA < LTMA
Relativity I: Price > STMA, Price < LTMA, STMA < LTMA
Relativity J: Price > STMA, Price = LTMA, STMA < LTMA
Relativity K: Price > STMA, Price > LTMA, STMA < LTMA
Relativity L: Price > STMA, Price > LTMA, STMA = LTMA
Relativity M: Price = STMA, Price = LTMA, STMA = LTMA
So what's the big deal, you may ask?
For the market to go from Bullish State (type A) to Bearish state (type G), the Market must pass through Relativity B, C, D, E, F.
For the market to go from Bearish State (type G) to Bullish state (type A), the Market must pass through Relativity H, I, J, K, L.
Knowing This principle helps you better plan when to enter a market, and when to exit a market, when to Lower your position and when to strengthen your position.


# Advanced Sample Hardhat Project

This project demonstrates an advanced Hardhat use case, integrating other tools commonly used alongside Hardhat in the ecosystem.

The project comes with a sample contract, a test for that contract, a sample script that deploys that contract, and an example of a task implementation, which simply lists the available accounts. It also comes with a variety of other tools, preconfigured to work with the project code.

Try running some of the following tasks:

```shell
npx hardhat accounts
npx hardhat compile
npx hardhat clean
npx hardhat test
npx hardhat node
npx hardhat help
REPORT_GAS=true npx hardhat test
npx hardhat coverage
npx hardhat run scripts/deploy.ts
TS_NODE_FILES=true npx ts-node scripts/deploy.ts
npx eslint '**/*.{js,ts}'
npx eslint '**/*.{js,ts}' --fix
npx prettier '**/*.{json,sol,md}' --check
npx prettier '**/*.{json,sol,md}' --write
npx solhint 'contracts/**/*.sol'
npx solhint 'contracts/**/*.sol' --fix
```

# Etherscan verification

To try out Etherscan verification, you first need to deploy a contract to an Ethereum network that's supported by Etherscan, such as Ropsten.

In this project, copy the .env.example file to a file named .env, and then edit it to fill in the details. Enter your Etherscan API key, your Ropsten node URL (eg from Alchemy), and the private key of the account which will send the deployment transaction. With a valid .env file in place, first deploy your contract:

```shell
hardhat run --network ropsten scripts/sample-script.ts
```

Then, copy the deployment address and paste it in to replace `DEPLOYED_CONTRACT_ADDRESS` in this command:

```shell
npx hardhat verify --network ropsten DEPLOYED_CONTRACT_ADDRESS "Hello, Hardhat!"
```

# Performance optimizations

For faster runs of your tests and scripts, consider skipping ts-node's type checking by setting the environment variable `TS_NODE_TRANSPILE_ONLY` to `1` in hardhat's environment. For more details see [the documentation](https://hardhat.org/guides/typescript.html#performance-optimizations).
