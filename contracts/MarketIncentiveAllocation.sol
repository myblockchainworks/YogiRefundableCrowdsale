pragma solidity ^0.4.15;

import 'zeppelin-solidity/contracts/math/SafeMath.sol';
import 'zeppelin-solidity/contracts/ownership/Ownable.sol';

import './YogiToken.sol';

contract MarketIncentiveAllocation is Ownable {

  using SafeMath for uint;

  uint public unlockedAt;
  YogiToken yogi;
  mapping (address => uint) allocations;
  uint tokensCreated = 0;
  uint constant public lockedMarketIncentiveAllocationTokens = 14000000e18;

  //address of the market storage vault
  address public marketStorageVault = 0x34b2413ac3508987f37Ea323907d30b9fdF6E44E;

  function MarketIncentiveAllocation() {
    yogi = YogiToken(msg.sender);
    // Locked time of approximately 3 months before team members are able to redeeem tokens.
    uint nineMonths = 3 * 30 days;
    unlockedAt = now.add(nineMonths);
    //20% tokens from the Marketing bucket which are locked for 3 months
    allocations[marketStorageVault] = lockedMarketIncentiveAllocationTokens;
  }

  function getTotalAllocation() returns (uint){
      return lockedMarketIncentiveAllocationTokens;
  }

  function unlock() external payable {
    require (now > unlockedAt);

    if (tokensCreated == 0) {
      tokensCreated = yogi.balanceOf(this);
    }

    //transfer the locked tokens to the teamStorageAddress
    yogi.transfer(marketStorageVault, tokensCreated);
  }
}
