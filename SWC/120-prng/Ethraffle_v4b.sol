pragma solidity ^0.4.16;

contract Ethraffle_v4b {
    struct Contestant {
        address addr;
        uint raffleId;
    }



    event TicketPurchase(
        uint raffleId,
        address contestant,
        uint number
    );

    event TicketRefund(
        uint raffleId,
        address contestant,
        uint number
    );

    // Constants
    uint public constant prize = 2.5 ether;
    uint public constant fee = 0.03 ether;
    uint public constant totalTickets = 50;
    uint public constant pricePerTicket = (prize + fee) / totalTickets; // Make sure this divides evenly
    address feeAddress;

    // Other internal variables
    bool public paused = false;
    uint public raffleId = 1;
    uint public blockNumber = block.number;
    uint nextTicket = 0;
    mapping (uint => Contestant) contestants;
    uint[] gaps;

    // Initialization
    function Ethraffle_v4b() public {
        feeAddress = msg.sender;
    }

    // Call buyTickets() when receiving Ether outside a function
    function () payable public {
        buyTickets();
    }

    function buyTickets() payable public {
        if (paused) {
            msg.sender.transfer(msg.value);
            return;
        }

        uint moneySent = msg.value;

        while (moneySent >= pricePerTicket && nextTicket < totalTickets) {
            uint currTicket = 0;
            if (gaps.length > 0) {
                currTicket = gaps[gaps.length-1];
                gaps.length--;
            } else {
                currTicket = nextTicket++;
            }

            contestants[currTicket] = Contestant(msg.sender, raffleId);
            TicketPurchase(raffleId, msg.sender, currTicket);
            moneySent -= pricePerTicket;
        }

        // Choose winner if we sold all the tickets
        if (nextTicket == totalTickets) {
            chooseWinner();
        }

        // Send back leftover money
        if (moneySent > 0) {
            msg.sender.transfer(moneySent);
        }
    }

    function chooseWinner() private {
        address seed1 = contestants[uint(block.coinbase) % totalTickets].addr;
        address seed2 = contestants[uint(msg.sender) % totalTickets].addr;
        uint seed3 = block.difficulty;
        bytes32 randHash = keccak256(seed1, seed2, seed3);

        uint winningNumber = uint(randHash) % totalTickets;
        address winningAddress = contestants[winningNumber].addr;
        //RaffleResult(raffleId, winningNumber, winningAddress, seed1, seed2, seed3, randHash);

        // Start next raffle
        raffleId++;
        nextTicket = 0;
        //blockNumber = block.number;

        // gaps.length = 0 isn't necessary here,
        // because buyTickets() eventually clears
        // the gaps array in the loop itself.

        // Distribute prize and fee
        winningAddress.transfer(prize);
        feeAddress.transfer(fee);
    }


}