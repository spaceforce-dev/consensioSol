import { expect } from "chai";
import { ethers, network } from "hardhat";
import BN from "bigNumber.js";

// For importing historical price data
import * as fs from "fs";
import * as path from "path";
import * as csv from "fast-csv";

describe("Consensio", async function () {
  let consensio: any;

  before("Should get the Moving Average config", async function () {
    const Consensio = await ethers.getContractFactory("Consensio");
    const delpoyedConsensio = await Consensio.deploy();
    consensio = await delpoyedConsensio.deployed();
  });

  it("Should get the Moving Average config", async function () {
    expect((await consensio.getMovingAverageDurationConfig())[0]).to.equal(180);
    expect((await consensio.getMovingAverageDurationConfig())[1]).to.equal(28);
  });

  it("Should load test price data", async function () {
    let prices: any[] = [];

    const uploadPrices = async function () {
      const numberOfDays = 200;
      await Promise.all(
        // Select the range of data
        prices.slice(0, numberOfDays).map(async (price) => {
          await consensio.getTime();
          await consensio.setPrice(new BN(new BN(price.price)).toFixed(0));
        })
      );
    };

    const myPromise = new Promise((resolve, reject) => {
      // Reverse price timline to get final 180 days prices
      fs.createReadStream(path.resolve(__dirname, "data", "coin_Bitcoin.csv"))
        .pipe(csv.parse({ headers: true }))
        .on("error", (error) => console.error(error))
        .on("data", (row) => {
          // Reverse
          prices.unshift({ price: row.Close, time: row.Date });
        })
        .on("end", async (rowCount: number) => {
          resolve(true);
        });
    });

    // Check the latest prices and that the second latest is a day older than the latest (data is in order)
    let finish = async function () {
      const length = await consensio.getAllPriceHistoryLength();
      const priceLatest = await consensio.getPriceHistorical(length - 1);
      const price2ndLatest = await consensio.getPriceHistorical(length - 2);
      expect(priceLatest[1]).to.be.above(price2ndLatest[1]);
    };

    await myPromise.then(uploadPrices).then(finish);
  });

  let decodeDirection = function (dir: any) {
    switch (dir) {
      case 0:
        return "DOWN";
      case 1:
        return "FLAT";
      case 2:
        return "UP";

      default:
        break;
    }
  };

  it("Should get the price direction state", async function () {
    const state = await consensio.getDirectionState();
    console.log(
      "Long term moving average (180 days): " + decodeDirection(state[0])
    );
    console.log(
      "Stort term moving average (28 days): " + decodeDirection(state[1])
    );
    console.log("Price moving average (2 days): " + decodeDirection(state[2]));
  });

  it("Should get the price direction score", async function () {
    const score = await consensio.getDirectionScore();
    console.log("Range: -13 <-> 12");
    console.log(score);
  });
});
