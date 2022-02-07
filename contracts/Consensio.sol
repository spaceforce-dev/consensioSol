//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract Consensio {

	// Setup fake time
	uint256 time;
	constructor() {
        time = 10000000;
    }

	// Memory to store price data
	// Price data could be gathered onchain from oracles if it's cost effective
	// or could be lookuped old rounds in Chainlink potentially
	// or Merkle tree off chain proof approach
	Price price;
	Price[] priceHistory;

	// Directions the moving average can be travelling
    enum direction {DOWN, FLAT, UP}

    struct DirectionState {
        direction LTMA;
        direction STMA;
        direction price;
    }

    struct MovingAverageDurationConfig {
        uint256 LTMA;
        uint256 STMA;
    }

	struct Price {
        uint256 Price;
        uint256 Time;
    }

	// Set config
	// Long Term Moving Average 180 day 
	// Short Term Moving Average 28 day 
    MovingAverageDurationConfig movingAverageDurationConfig = MovingAverageDurationConfig(
        180,
        28
    );

	function getTime() public view returns (uint256) {
		return block.timestamp;
	}

    function getPriceCurrent() public view returns (uint256) {
        uint256 price = 1;
        return price;
    }

    function getPriceHistorical(
        uint256 daysAgo
    ) public view returns (Price memory) {
        return priceHistory[daysAgo];
    }

	function getAllPriceHistorical() public view returns (Price[] memory) {
        return priceHistory;
    }

	function getAllPriceHistoryLength() public view returns (uint) {
        return priceHistory.length;
    }

    function getMovingAverageDurationConfig()
        public
        view
        returns (MovingAverageDurationConfig memory)
    {
        return movingAverageDurationConfig;
    }

	function rawDirectionInterpreter(uint256 raw) 
		private
        view
        returns (direction)
    {
		// 0 = down
		// 1 = neutral
		// 2 = up
		if (raw == 0) {
			return direction.DOWN;
		} else if (raw == 1) { 
			return direction.FLAT;
		} else if (raw == 2) { 
			return direction.UP;
		}
	}

	function getDirectionState() 
		public
        view
        returns (DirectionState memory)
    {
		direction LT = rawDirectionInterpreter(getDirection(0, movingAverageDurationConfig.LTMA)[1]);
		direction ST = rawDirectionInterpreter(getDirection(0, movingAverageDurationConfig.STMA)[1]);
		direction P = rawDirectionInterpreter(getDirection(0, 1)[1]);

        return DirectionState(
			LT,
			ST,
			P
		);
    }

	function getDirectionScore() 
		public
        view
        returns (int)
    {
		uint256 LT = getDirection(0, movingAverageDurationConfig.LTMA)[1];
		uint256 ST = getDirection(0, movingAverageDurationConfig.STMA)[1];
		uint256 P = getDirection(0, 1)[1];

        return int(9 * LT + 3 * ST + 1 * P) - 13;
    }

	function getDirection(uint from, uint to)
        public
        view
        returns (uint256[2] memory)
    {
		require(to < priceHistory.length);
		uint256 currentMaAccumulator = 0;
		uint256[2] memory rawDirection;
		
		for (uint i = 0; i <= to; i++) {
			currentMaAccumulator = currentMaAccumulator + priceHistory[i].Price;
		}

		uint256 oldMaAccumulator = 0;

		for (uint j = 4; j <= to + 4; j++) {
			oldMaAccumulator = oldMaAccumulator + priceHistory[j].Price;
		}

		uint256 currentMa = currentMaAccumulator / to;
		uint256 oldMa = oldMaAccumulator / to;

		// 0 = down
		// 1 = neutral
		// 2 = up
		if (currentMa > oldMa) {
			// trend is up
			rawDirection = [currentMa - oldMa, 2];
		} else if (currentMa < oldMa) {
			// trend is down
			rawDirection = [oldMa - currentMa, 0];
		}  else  {
			uint256 ma = 0;
			rawDirection = [ma, 1];
		}
		return rawDirection;
    }

	// Used to backdate the price
    function setPrice(uint256 price_) public returns (Price memory) {
        price = Price(price_, time);
		// Mocking time for testing
		time = time + 86400;
		priceHistory.push(price);
        return price;
    }
}