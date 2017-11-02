var YogiRefundableCrowdsale = artifacts.require("./YogiRefundableCrowdsale.sol");

function latestTime() {
  return web3.eth.getBlock('latest').timestamp;
}

const duration = {
  seconds: function(val) { return val},
  minutes: function(val) { return val * this.seconds(60) },
  hours:   function(val) { return val * this.minutes(60) },
  days:    function(val) { return val * this.hours(24) },
  weeks:   function(val) { return val * this.days(7) },
  years:   function(val) { return val * this.days(365)}
};

module.exports = function(deployer) {
  //uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, uint256 _goal

  const startTime = latestTime() + duration.minutes(5);
  const endTime = startTime + duration.days(3);
  const rate = 1000;
  const wallet = "0x895324D4d8E9Bf08db6C78d828B8498291e7AB4c";
  const softCap = web3.toWei('15', 'ether');
  const hardCap = web3.toWei('100', 'ether');
  console.log([startTime, endTime, rate, wallet, softCap, hardCap]);
  deployer.deploy(YogiRefundableCrowdsale, startTime, endTime, rate, wallet, softCap, hardCap, {gas: '6952225'});
};
