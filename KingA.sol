// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract KingA {
    function claimKingship(address payable _to) public payable {
        (bool sent, ) = _to.call.value(msg.value)("");
        require(sent, "Failed to send value!");
    }
}
