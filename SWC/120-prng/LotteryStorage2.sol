contract RandomTimestamp{
    struct Bet {
        uint betAmount;
        uint blockNumber;
        bool won;
    }

    Bet[] private bets;


     function makeBet() {
        // Won if block number is even
        // (note: this is a terrible source of randomness, please don't use this with real money)
        uint8 won = uint8(keccak256(block.timestamp, block.difficulty))%251;

        // Record the bet with an event
        bets[won]=Bet(msg.value, block.number, false);

    }

}