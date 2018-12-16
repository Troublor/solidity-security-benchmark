contract LotteryAddress {
    event GetBet(uint betAmount, uint blockNumber, bool won);

    struct Bet {
        uint betAmount;
        uint blockNumber;
        bool won;
    }

    address private organizer;
    Bet[] private bets;

    // Create a new lottery with numOfBets supported bets.
    function Lottery() {
        organizer = msg.sender;
    }

    // Fallback function returns ether
    function() {
        throw;
    }

    // Make a bet
    function makeBet() {
        // Won if block number is even
        // (note: this is a terrible source of randomness, please don't use this with real money)
        uint won = block.number % 2;

        // Record the bet with an event
        bets[won]=Bet(msg.value, block.number, false);

    }


    // Suicide :(
    function destroy() {
        if(msg.sender != organizer) { throw; }

        suicide(organizer);
    }
}