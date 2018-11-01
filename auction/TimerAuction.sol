pragma solidity ^0.4.25;

import "./BaseAuction.sol";

/*
Simple time-based auction that declares winning bid after a specified number
of minutes has passed since contract creation
*/
contract TimerAuction is BaseAuction {

    string public item;
    uint public auctionEnd;
    address public maxBidder;
    uint public maxBid;
    bool public ended;

    event BidAccepted(address bidder, uint bid);

    constructor(string _item, uint _durationMinutes) internal {
        item = _item;
        auctionEnd = now + (_durationMinutes * 1 minutes);
    }

    function bid() public payable {
        //make sure auction hasnt already ended
        require(now < auctionEnd);
        //make sure bid is higher than current max
        require(msg.value > maxBid);

        //return the bid amount that got beat
        if(maxBidder != 0){
            //WARNING: THIS IS UNSAFE!
            maxBidder.transfer(maxBid);
        }

	//update new max bidder
        maxBidder = msg.sender;
        maxBid = msg.value;
        emit BidAccepted(maxBidder, maxBid);
    }

    function end() public ownerOnly {
        //make sure this function only called once
        require(!ended);
        //make sure owner cant declare winner before time is up
        require(now >= auctionEnd);

        //set the flag
        ended = true;
        //announce the winner
        emit AuctionComplete(maxBidder, maxBid);

        //WARNING: THIS IS UNSAFE!
        owner.transfer(maxBid);
    }
}
