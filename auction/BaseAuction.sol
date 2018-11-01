pragma solidity ^0.4.25;

import "./AuctionInterface.sol";

/*
Base contract class that keeps track of the auction owner, and provides
an event to announce the winner at the end of the auction
*/
contract BaseAuction is Auction {

    address public owner;

    modifier ownerOnly(){
        require(msg.sender == owner);
        _;
    }

    event AuctionComplete(address winner, uint bid);

     constructor() internal {
        owner = msg.sender;
    }
}
