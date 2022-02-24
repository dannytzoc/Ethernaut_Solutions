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
In order to do that all we need to is call the contribute function inside our web console and contribute after that all we need to is call the fallback function and then withdraw the amount that belong to the owner with the withdraw function inside the contract 
```
  function withdraw() public onlyOwner {
    owner.transfer(address(this).balance);
  }
  ```
  To contribute all you need to do is call 
  ```
  contract.contribute({value:1})
  ```
  1 which would be one WEI and to get an idea 1 ether is 10^18 wei
  After that we are part of the mapping then all we need to do is call fallback function in our console just by doing this in web console 
 ```
 contract.sendTransaction{value:1})
```
After you just call the withdraw funnction and see that the contract got drained and you can submit your instance 
```
contract.withdraw()
```
## Fallout 
Fallout was an easy level. In this level the main exploit was in the constructor part. In the constructor there seemed to be a typo. Execpt of writing Fallout they instead had it as Fal1out. Having it like this it allowed an attacker to call the this function. If you would to see the code whoever called this function gets to be owner because of msg.sender

```
function Fal1out() public payable {
    owner = msg.sender;
    allocations[owner] = msg.value;
  }
```
In order to solve this level all you need to do is go to the console and just call the function simply by typing 
```
contract.Fal1out()
```
## CoinFlip 
When you a flip a coin you exepect a 50/50 chance of winning. You execpt either tails or heads to popup. The problem with randomness or chance is that Etherum is a deterministic Turning machine. Determinitic is if there is only one possible action at each step. So in etherum a transaction needs to be confirmed by more than one node in the network. This means that every node must come to the same conclusion. 

In the case with coniflip you can easily write an advesary contract that is able to mimic the functionality to guess the outcome of the coinflip 
The malicouse contract would be posted on this github label CoinFlipA.sol

## Telephone 
To pass this level of ethernaut you must claim ownership of the contract. In order to claim ownership of this contract you must first understand the difference between tx.origin and msg.sender. 

tx.origin refers to the orgialn external contract that started the transaction while msg.sender refers to the immediate account. So in this level the main thing you have to focus on is in this if statment 
```
  if (tx.origin != msg.sender) {
      owner = _owner;
    }
```
You will need to write a malicouse contract. that calls chageowner within it. 

The malicouse contract would be inside a file called TelephoneA.sol

