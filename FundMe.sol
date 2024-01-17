// SPDX-License-Identifier: MIT

//pragma solidity >=0.6.6 <0.9.0;
pragma solidity ^0.6.0;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";

// send some funds to a contract
contract FundMe {

    using SafeMathChainlink for uint256;

    mapping(address => uint256) public addressToAmountFunded;
    address[] public funders;
    address public owner;  // should be the address of your eth wallet 

    constructor() public {
        owner = msg.sender;
    }

    function fund() public payable {
        uint256 minimumUSD = 50 * 10 **18;
        // won't execute the contract if following condition net met
        // what the ETH -> USD conversion rate
        require(getConversionRate(msg.value) >= minimumUSD, "You need to spend more eth!");
        addressToAmountFunded[msg.sender]  += msg.value;
        funders.push(msg.sender);
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
    
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function withdraw() payable onlyOwner public {
        msg.sender.transfer(address(this).balance);
        // after withdrawer, reset the funders
        for (uint256 funderIndex=0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);
    }

}
