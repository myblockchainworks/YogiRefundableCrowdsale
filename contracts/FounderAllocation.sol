pragma solidity ^0.4.15;

import 'zeppelin-solidity/contracts/math/SafeMath.sol';
import 'zeppelin-solidity/contracts/ownership/Ownable.sol';

import './YogiToken.sol';

contract FounderAllocation is Ownable {

  using SafeMath for uint;

  uint public unlockedAt;
  YogiToken yogi;
  mapping (address => uint) allocations;
  uint tokensCreated = 0;
  uint constant public lockedFounderAllocationTokens = 21000000e18;

  //address of the founder storage vault
  address public founderStorageVault = 0x34b2413ac3508987f37Ea323907d30b9fdF6E44E;

  function FounderAllocation() {
    yogi = YogiToken(msg.sender);
    // Locked time of approximately 9 months before team members are able to redeeem tokens.
    uint nineMonths = 9 * 30 days;
    unlockedAt = now.add(nineMonths);
    //30% tokens from the Marketing bucket which are locked for 9 months
    allocations[founderStorageVault] = lockedFounderAllocationTokens;
  }

  function getTotalAllocation() returns (uint){
      return lockedFounderAllocationTokens;
  }

  function unlock() external payable {
    require (now > unlockedAt);

    if (tokensCreated == 0) {
      tokensCreated = yogi.balanceOf(this);
    }

    //transfer the locked tokens to the teamStorageAddress
    yogi.transfer(founderStorageVault, tokensCreated);
  }
}
