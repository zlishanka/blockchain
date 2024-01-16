// SPDX-License-Identifier: MIT

//pragma solidity >=0.6.6 <0.9.0;
pragma solidity ^0.6.0;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";

contract FundMe {

    using SafeMathChainlink for uint256;

    mapping(address => uint256) public addressToAmountFunded;

    function fund() public payable {
        uint256 minimumUSD = 50 * 10 **18;
        // won't execute the contract if following condition net met
        // 1gwei < $50
        require(getConversionRate(msg.value) >= minimumUSD, "You need to spend more eth!");
        addressToAmountFunded[msg.sender]  += msg.value;
        // what the ETH -> USD conversion rate

    }

    function getVersion() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return priceFeed.version();

    }

    function getPrice() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        // returned as tuple 
        (
            // uint80 roundId,
            // int answer,
            // uint startedAt,
            // uint timeStamp,
            // uint80 answeredInRound
            ,int answer,,,
         ) = priceFeed.latestRoundData();
         return uint256(answer * 10000000000);
    }

    //1000000000
    function getConversionRate(uint256 ethAmount) public view returns (uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1000000000000000000;
        return ethAmountInUsd;

    }

}
