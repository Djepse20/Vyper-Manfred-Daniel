# @version ^0.2.0

#contract to create a dutch auction


#storage variables
contract_owner: address
item: public(String[1000])
auctiontime: public(uint256)
auctionstarttime: public(uint256)
auctionend: public(uint256)
temp: uint256
result: uint256
pricetemp: decimal
auctionstartingprice: public(uint256)
auctioncurrentprice: public(uint256)
auctionactive: public(bool)
shares: public(uint256)
beneficiarybalance: uint256
bidderid: uint256

#hashmap
bid_index: HashMap[address, uint256]


@external
def __init__(_auctiontime: uint256,_item: String[1000],_shares: uint256,_auctionstartingprice: uint256):
    self.contract_owner = msg.sender
    self.item = _item
    self.auctiontime = _auctiontime
    self.auctionstarttime = block.timestamp
    self.auctionend = self.auctionstarttime + self.auctiontime
    self.auctionstartingprice = _auctionstartingprice * (10**18)
    self.auctioncurrentprice = self.auctionstartingprice
    self.shares = _shares
    self.temp = 0
    self.result = 0
    self.bidderid = 0
    self.auctionactive = True
    self.beneficiarybalance = 0
    self.pricetemp = 0.0

@internal
def _priceslope():
    assert block.timestamp < self.auctionend
    timer: uint256 = 60
    self.result = (block.timestamp - self.auctionstarttime) / timer
    if self.temp == self.result:
        self.auctioncurrentprice = self.auctioncurrentprice
    else:
        self.auctioncurrentprice = self.auctionstartingprice - (self.result * (10**18))
    
    self.temp = self.result

@external
@view
def currentprice() -> uint256:
    return self.auctioncurrentprice

@external
@view
def isauctionactive() -> bool:
    return self.auctionactive

@payable
@external
def bid(shares: uint256):
    assert block.timestamp < self.auctionend, "The auction has ended!"  

    assert msg.sender != self.contract_owner
    
    assert block.timestamp > self.auctionstarttime, "The auction has not started yet!"

    assert self.shares - shares != 0, "There is no more shares left!"

    self._priceslope()

    assert msg.value >= (shares * self.auctioncurrentprice), "The bid is too low compared to the current price!"

    self.bid_index[msg.sender] = shares
    self.shares -= shares
    self.beneficiarybalance += msg.value


@external
def withdraw():
    assert block.timestamp >= self.auctionend
    assert not self.auctionactive
    pendingreturns: uint256 = self.bid_index[msg.sender]
    send(msg.sender, pendingreturns)


@external
def endAuction():
    assert block.timestamp >= self.auctionend
    assert not self.auctionactive
    send(self.contract_owner, self.beneficiarybalance)
