// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract ForceA {
constructor() public payable{
}
function self_force(address payable force_address){
selfdestruct(force_address);
}
}
