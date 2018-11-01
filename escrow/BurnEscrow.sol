pragma solidity ^0.4.25;

import "./EscrowBase.sol";

contract BurnEscrow is EscrowBase {

    modifier buyerOnly() {
        _;
        require(msg.sender == buyer);
    }

    modifier correctPrice() {
        require(msg.value == price);
        _;
    }

    modifier sellerOnly() {
        require(msg.sender == seller);
        _;
    }

    address public buyer;
    address public seller;

    uint public price;

    bool public buyer_in;
    bool public seller_in;

    constructor(address _buyer, address _seller, uint _price) {
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
        placeInEscrow();
    }

    function confirmDelivery() buyerOnly inState(State.AWAITING_DELIVERY) {
        completeTransaction();
    }

    function buyerCollectEscrow() buyerOnly inState(State.COMPLETE) {
        buyer.transfer(price);
    }

    function sellerCollectEscrow() sellerOnly inState(State.COMPLETE) {
        seller.transfer(price);
    }

    function sellerCollectPayment() sellerOnly inState(State.COMPLETE) {
        seller.transfer(price);
    }
}
