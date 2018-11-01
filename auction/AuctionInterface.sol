pragma solidity ^0.4.25;

/*
Interface for an auction contract that allows submitting bids,
and the ability to end the contract and declare a winner
*/
interface Auction {

    /*
    Accepts a bid in ether
    */
    function bid() external payable;

    /*
    Ends the auction and declares a winner
    */
    function end() external;
}
