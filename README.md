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
## King 
When solving the king of ether solidity problem look at this part of the code hat is most explitable which is below 
```
    king.transfer(msg.value);
```
In this case the king has a fallback function that is able to reclaim ownership. So in our case we have to deploy a malicouse contract 
that has a malicouse fallback function or no fallback function. KingA.sol is going to have solution.

## Reentrancy 
A popular type of exploit in smart contract. Basic Idea of Reentrancy 
Example 
Suppose you have contract A and contract B. Contract A calls contract B and Contract B can call Contract A while Contract A is still executing. This technique can be used to drain smart contract. 
This problem had me stuck for the most part because if you where to look at writeups or videos because this is such an old challenge the contract started off with 1 ether but in the newest version of this challenge it start off with .001 ether so to fix this I just donate enough ether to make it 2 ether 
```
await contract.donate("insert your attacker contract's address here",{value: ethers.toWei("whatever makes 2 ", "ether")})

```
After that all you need to do is to write a reentracy exploit on a malicouse contract. This would be ReenA.sol

## Elevator 
The main security issue with elevator is that we are able to implement it because the building interface does not implement it inside the function 
So all we have to do is write a function for islastfloor that passess both cases so we can make top true
```
answer = true
function isLastFloor(uint) external returns(bool){
answer = !answer;
return answer
}
```
Thats basically all you do in your malicouse code 

## Privacy 
The privacy challenge in Ethernaut is similar to the Force in which you have to understand etherum storage. 
this is the part of the code you need to focus on 
```
bool public locked = true;
  uint256 public ID = block.timestamp;
  uint8 private flattening = 10;
  uint8 private denomination = 255;
  uint16 private awkwardness = uint16(now);
  bytes32[3] private data;
```
Understanding ehterum storage you will now that locked will be at 0 
public id at 1 flattening-awkwardness will be 2 and bytes [0] will be 3 bytes[1] will be 4 and bytes[2] wull be 5 and bytes[2] seesm to unlock it so to unlock it all we wll need to do is just this 
```
key = await web3.eth.getStorageAt(contract.address, 5)

```
This value would still be in 32bytes and we need to do it in 16bytes and to do that we need to slice it with a function like this 

```
key = key.slice(0, 34)
await contract.unlock(key) // this should solve it 

```
That should solve your problem 

## Gatekeeper One 
This is one of the difficult challenges i ran into because the gate one is pretty easy but passing gate two was such a pain.
Gate one was basically just writing an intemediary contract because of tx.origin and msg.sender

The next part is pretty tricky and honestly seems kinda of waste because it makes it very hard to understand gas operation in solidity so im leave this part blank 

Passing gate 3 is basically a bit of bit mask operation 

The code will be avaible in GateKeeperOne.sol

## Gatekeeper Two 
Gatekeeper Two is a lot easier to solve because yu dont have to worry to debuginng and find the amount of gas in contract. 
So in this level you are going to need a middle man contract like before to pass the first gate. In the second gate it looking for your calling contract size to be size zero and in order to do that you can just call the function inside the constructor and to solve gate 3 its basically understanding xor functionality which is basically a ^ b = c which is b = a ^c.
So the answer for that would be 
```
uint64(_gateKey) = uint64(keccak256(msg.sender)) ^ uint64(0) — 1)
```
The code would in gatekeepertwo.sol

## Naught Coin 
With naught coin its bascially poor erc20 inheritcance. They trusted to much in ERC20. If you where to look at the erc20 it looks like transferfrom you can still use and transfer you cant use since it has a modifier. So in this mode you dont need to write code all you need to do is just approve yourself and use the transferfrom function 
To do that all you do is 
```
await contract.approve(player,'amount of tokens');
```

```
await contract.transfer(player,'random address', 'amount of tokens');
```
Then submit it

## Preservation 
This challenges uses the idea of storage with solodity and delegate call with solidity. 
In order to pass this level all you need to do is match up the storage spaces with that of the contract and when you call delegate call all you need to do is just switch the owner to your wallet and you shoould be owner wallet. delegeate call seems to call a function called setTime(uint256) all you need to do in your middle wallet is to rename the function and you should be pass  owner = msg.sender; inside the function call the function on remix and sumbit the instance and that about it. The code would be in presa

## Recovery 
This is a very easy level all you have to do is recover a contract address. There is two ways to do this but the simple way is by looking at etherscan inside internal txns and click on the contract and you should get the lost contract address. The other way is to calcualte the address by using this function 
address = rightmost_20_bytes(keccak(RLP(sender address, nonce)))
I used etherscan becuase it was easier 

## Magic Number
It also had to do with etherum opcode virtualization you are supposed to have a good understading of evm opdcode. 
The answer is basically 
```
bytecode = '600a600c600039600a6000f3602a60505260206050f3'

txn = await web3.eth.sendTransaction({from: player, data: bytecode})
```
```
solverAddr = txn.contractAddress
```
```
await contract.setSolver(solverAddr)
```
## Alien Codex

First step to solve this level is to pass the check call the make_contact function and then modify the length of the codex 
```
await contract.make_contact()
await contract.retract()

```
Caclualte the postion storage of the start of codex array 
```
p = web3.utils.keccak256(web3.eth.abi.encodeParameters(["uint256"], [1]))

```
Caclualte the require index 
```
i = BigInt(2 ** 256) - BigInt(p)
```

Slice of the zeros 
```
content = '0x' + '0'.repeat(24) + player.slice(2)
```

Now revise alter sotrage slot 
```
await contract.revise(i, content)
```
then hijack alien codex 

```
await contract.revise(i, content)
```
## Denial 
The goal of this challnge is to Deny funds. The very first step is to make an attacking contract and inside you will need to add a fallback function. Then inside the callback function you while write an infiite loop to consume all th gas. Finally you will deploy your contract and set address to your attacker contract. 
The reason on why this work is because the external call doesnt check the return value is susceptible to the costly loop to consume all gas. 
## Shop 
To pass this level a buyer can cheat by returning a legit value in price to pass the first if statment and during the second invocation they can set the price of the prodcut. The code will be in ShopA.sol
