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

Create a malicouse contract that calls the changeowner function within the malciouse contract so it can bypass the if statment 

## Token 
Before Solidity version 0.8.0 solidity was susestibale to buffer overflow and buffer underflow. You could not use + , - , / , or *
If you wanted to use arithmethic functions you have to use Safe Math library that can protect you with buffer overflow and underflow. Right now in the recent solidity you do not have to worry anymore. 

```
 function transfer(address _to, uint _value) public returns (bool) {
    require(balances[msg.sender] - _value >= 0);
    balances[msg.sender] -= _value;
    balances[_to] += _value;
    return true;
  }

```
The problem stated you start off with 20 tokens so in order to beat this problem you will need to send a value of greater than 21 to cause a buffer overflow 
For example 
20-21 = -1 in normal circumstance but since it and uint it would cause a buffer overflow since negatives do not exist in uint 
so it would be 255 
To solve this just write this on the console and then just submit 
```
await contract.transfer("random_address", 21);

```
## Delegation 
To solve this problem you first have to understand how delegatecall works. Delegatecall is a low level function. In the solidity docs it states 'When contract A executes delegatecall to contract B, B's code is excuted with contract A's storage, msg.sender and msg.value.' In other words Contract A is able to call function that Contrract B has. 

In this contract it looks like Delegation has a fallback function that contains a delegatecall and if you where to look at Delegate Contract it looks like you can call the pwn function so you can switch owner of the account. 

In the challange it also said to look at fallback methods and methods ID 
Fallback methods is what I found in this forum https://ethereum.stackexchange.com/questions/23369/fallback-function-in-web3 
The Method ID. This is derived as the first 4 bytes of the Keccak hash of the ASCII form of the signature baz(uint32,bool).

To simply solve this problem all you need to do is bacially this two steps 
First create variable that will hold the function hash 
```
var pwn_hash = web3.utils.sha3("pwn()");
```
Then you will use the send transaction function
```
contract.sendTransaction({data:pwn_hash});
```
## Force 
The goal of this contract is to make the balance of FOrce contract more than zero. Things that might help is to look at fallback methods while researching fallabck methods I found a function that was intresting that it called selfdestruct. Selfdestruct is a function that lets you move all the ether that a smar contract has to another address. This level is fairly easy just make a malciouse contract and have it hold some ether and just use the self destruct funtion to send Force contract some ether. 
The code would be in ForceA.sol

#Vaulet 
Lesson for this challenge is that eveything is public in the blockchain. Do not store password in the blockchain how in this challenge does. This was fairly simple first you must get the storage location of contract password which is 1 so you will do a simple
```
web3.getStorageAt(contract.address,1);
```
Then you will convert it to ascii using web3 library
```
web3.utils.hexToAscii("hex value");
```
Finally you will unlock this challenge by calling 
```
contract.unlock("password");
```
