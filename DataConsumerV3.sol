// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

/**
 * THIS IS AN EXAMPLE CONTRACT THAT USES HARDCODED
 * VALUES FOR CLARITY.
 * THIS IS AN EXAMPLE CONTRACT THAT USES UN-AUDITED CODE.
 * DO NOT USE THIS CODE IN PRODUCTION.
 */

/**
 * If you are reading data feeds on L2 networks, you must
 * check the latest answer from the L2 Sequencer Uptime
 * Feed to ensure that the data is accurate in the event
 * of an L2 sequencer outage. See the
 * https://docs.chain.link/data-feeds/l2-sequencer-feeds
 * page for details.
 */

contract DataConsumerV3 {
    //AggregatorV3Interface internal dataFeed;
    AggregatorV3Interface internal priceFeed;

    /**
    * Network: Sepolia
    * Data Feed: ETH/USD
    * Address: 0x694AA1769357215DE4FAC081bf1f309aDC325306
    */
    constructor() {
        priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
    }


    // /**
    //  * Network: Sepolia
    //  * Aggregator: BTC/USD
    //  * Address: 0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43
    //  */
    // constructor() {
    //     dataFeed = AggregatorV3Interface(
    //         0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43
    //     );
    // }

    /**
     * Returns the latest answer.
     */
    // function getChainlinkDataFeedLatestAnswer() public view returns (int) {
    function getLatestPrice() public view returns (int) {
        (
            /* uint80 roundID */,
            int answer,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        // ) = dataFeed.latestRoundData();
         ) = priceFeed.latestRoundData();
        return answer;
    }
}

