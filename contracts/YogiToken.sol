pragma solidity ^0.4.15;

import 'zeppelin-solidity/contracts/token/MintableToken.sol';
import 'zeppelin-solidity/contracts/token/PausableToken.sol';

contract YogiToken is MintableToken, PausableToken {
  string public constant name = "YOGI Token";
  string public constant symbol = "YOGI";
  uint8 public constant decimals = 18;
}
