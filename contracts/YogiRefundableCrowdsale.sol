pragma solidity ^0.4.15;

import 'zeppelin-solidity/contracts/crowdsale/Crowdsale.sol';
import 'zeppelin-solidity/contracts/crowdsale/RefundableCrowdsale.sol';
import 'zeppelin-solidity/contracts/crowdsale/CappedCrowdsale.sol';

import './YogiToken.sol';
import './FounderAllocation.sol';
import './MarketIncentiveAllocation.sol';

contract YogiRefundableCrowdsale is RefundableCrowdsale, CappedCrowdsale {

  uint public minContribAmount = 0.1 ether; // 0.1 ether

  uint public publicAllocationTokens = 35000000e18;
  uint constant public lockedFounderAllocationTokens = 21000000e18;
  uint constant public lockedMarketIncentiveAllocationTokens = 14000000e18;

  FounderAllocation public founderAllocation;
  MarketIncentiveAllocation public marketIncentiveAllocation;

  function YogiRefundableCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, uint256 _goal, uint256 _cap)
  Crowdsale(_startTime, _endTime, _rate, _wallet) RefundableCrowdsale(_goal) CappedCrowdsale(_cap)
  {
  }

  function createTokenContract() internal returns (MintableToken) {
    return new YogiToken();
  }

  function buyTokens(address beneficiary) public payable {
    require(beneficiary != address(0));
    require(validPurchase());

    uint256 weiAmount = msg.value;
    // calculate token amount to be created
    uint256 tokens = weiAmount.mul(rate);
    uint timebasedBonus = tokens.mul(getTimebasedBonusRate()).div(100);
    tokens = tokens.add(timebasedBonus);

    assert (tokens <= publicAllocationTokens);
    publicAllocationTokens = publicAllocationTokens.sub(tokens);
    // update state
    weiRaised = weiRaised.add(weiAmount);

    token.mint(beneficiary, tokens);
    TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);

    forwardFunds();
  }

  function validPurchase() internal constant returns (bool) {
      bool minContribution = minContribAmount <= msg.value;
      return super.validPurchase() && minContribution;
  }

  // Get the time-based bonus rate
  function getTimebasedBonusRate() internal constant returns (uint256) {
      uint256 bonusRate = 0;
      uint days20 = startTime + (20 days);
      if (now <= days20) {
          bonusRate = 10;
      }
      return bonusRate;
  }

  function finalization() internal {
    //Allot founder tokens to a smart contract which will frozen for 9 months
    founderAllocation = new FounderAllocation();
    token.mint(address(founderAllocation), lockedFounderAllocationTokens);

    //Allot market incentive tokens to a smart contract which will frozen for 3 months
    marketIncentiveAllocation = new MarketIncentiveAllocation();
    token.mint(address(marketIncentiveAllocation), lockedMarketIncentiveAllocationTokens);

    super.finalization();
  }
}
