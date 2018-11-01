pragma solidity ^0.4.25;

contract EscrowBase {
    enum State { UNINITIATED, AWAITING_PAYMENT, AWAITING_DELIVERY, COMPLETE, IN_DISPUTE, REFUNDED }
    State currentState;

    modifier inState(State expectedState) {
        require(currentState == expectedState);
        _;
    }

    function placeInEscrow() inState(State.AWAITING_PAYMENT) {
        currentState = State.AWAITING_DELIVERY;
    }

    function completeTransaction() inState(State.AWAITING_DELIVERY) {
        currentState = State.COMPLETE;
    }

    function raiseDispute() inState(State.AWAITING_DELIVERY) {
        currentState = State.IN_DISPUTE;
    }

    function resolveDispute(bool _resolved) inState(State.IN_DISPUTE) {
        if (_resolved) {
            currentState = State.AWAITING_DELIVERY;
        } else {
            currentState = State.REFUNDED;
        }
    }

}
