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
  const endTime = startTime + duration.days(1);
  const rate = 1000;
  const wallet = "0x48a5a991AFE573feD8cC2269197232AEA23F07f0";
  const softCap = web3.toWei('2', 'ether');
  const hardCap = web3.toWei('5', 'ether');
  console.log([startTime, endTime, rate, wallet, softCap, hardCap]);
  deployer.deploy(YogiRefundableCrowdsale, startTime, endTime, rate, wallet, softCap, hardCap); //, {gas: '6952225'}
};
