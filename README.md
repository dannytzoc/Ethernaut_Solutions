# Ethernaut Solutions 
by Danny Tzoc 

## Fallback 
What is Fallback?
Fallback is a solidity function that gets called when a function does not exist. It is also used to directly send ether. 
In this specific challenge looking at the contract we see that there is a mapping of the contributions and we see an owner and a fallback function. 
Examining the fallback function we notice that whoever calls the fallback function gets to be the owner but there is a require function. To pass that require function we are going to need to send a value greater than zero and we have to be in the mapping of the it. 
```
  receive() external payable {
    require(msg.value > 0 && contributions[msg.sender] > 0);
    owner = msg.sender;
  }
```
