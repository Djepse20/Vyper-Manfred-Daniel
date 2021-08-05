

#Patreon contract, work in progress
#created by Daniel Dencker Jepsen

#pragma line
# @version ^0.2.0
#Contract Firstprogram

_PatreonToSendTo: public(address)
_patreons: HashMaps[address,Patreon]
_subscribers: HashMaps[address,subscribers]

struct subscribers:
    _address: address
    _username: string
    _value: uint256
    _interval: uint256
event Subscribe:
    _SubscriberAdress: indexed(address)
    _patreonAddress: indexed(address)
struct Patreon:
    _address: address
    _username: string
    _minimumValue: uint256
    _subscribers: self.subscribers









@external
def __init__():
    self._PatreonToSendTo = empty(address)

@internal
def Ether_to_wei(wei_value: uint256) -> uint256:
    return wei_value/(10**18)

@external
def setbalance(_address: address):
    self._balanceOfAddress = self.Ether_to_wei(_address.balance)

@payable 
@external
def sendweiToContractOwner():
    send(self,msg.value)

#subscribe to a patreon
@payable 
@external
def SubScribeToPatreon(_patreonAddress: address, _interval: uint256, _username: string):
    assert self._patreons[address] != emtpy(self.Patreon), "Patreon does not exist"
    assert  msg.value >= self._patreons[_patreonAddress]._MinimumValue, "MinimumValue not send with call"
    self._subscribers[msg.sender].address = msg.sender
    self._subscribers[msg.sender]._username = _username
    self._subscribers[msg.sender]._interval = interval



#this functions will get call at an interval,
@payable 
@external
def SendWeiToPatreon():
    msg.value
