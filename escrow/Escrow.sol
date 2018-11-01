pragma solidity ^0.4.25;

/*
Simple escrow contract that mediates disputes using a burn contract
*/

contract Escrow {

    enum State {UNINITIATED, AWAITING_PAYMENT, AWAITING_DELIVERY, COMPLETE}
    State public currentState;

    modifier inState(State expectedState) { require(currentState == expectedState); _; }

    modifier buyerOnly() { require(msg.sender == buyer); _; }

    modifier correctPrice() { require(msg.value == price); _; }

    address public buyer;
    address public seller;

    bool public buyer_in;
    bool public seller_in;

    uint public price;

    constructor(address _buyer, address _seller, uint _price){
        buyer = _buyer;
        seller = _seller;
        price = _price;
    }

    function initiateContract() correctPrice inState(State.UNINITIATED) payable {
        if (msg.sender == buyer) {
            buyer_in = true;
        }
        if (msg.sender == seller) {
            seller_in = true;
        }
        if (buyer_in && seller_in) {
            currentState = State.AWAITING_PAYMENT;
        }
    }

    function sendPayment() buyerOnly correctPrice inState(State.AWAITING_PAYMENT) payable {
        currentState = State.AWAITING_DELIVERY;
    }

    function confirmDelivery() buyerOnly inState(State.AWAITING_DELIVERY) {
        buyer.transfer(price);
        seller.transfer(price * 2);
        currentState = State.COMPLETE;
    }
}
