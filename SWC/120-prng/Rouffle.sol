contract Rouffle{
    uint privSeed=321;

    function guess(uint guess) payable{
        if(guess == generateRand()){
            msg.sender.transfer(1 ether);
        }
    }

    function generateRand() private returns (uint) {
        // Seeds
        privSeed = (privSeed*3 + 1) / 2;
        privSeed = privSeed % 10**9;
        uint number = block.number; // ~ 10**5 ; 60000
        uint diff = block.difficulty; // ~ 2 Tera = 2*10**12; 1731430114620
        uint time = block.timestamp; // ~ 2 Giga = 2*10**9; 1439147273
        uint gas = block.gaslimit; // ~ 3 Mega = 3*10**6
        // Rand Number in Percent
        uint total = privSeed + number + diff + time + gas;
        uint rand = total % 37;
        return rand;
    }
}