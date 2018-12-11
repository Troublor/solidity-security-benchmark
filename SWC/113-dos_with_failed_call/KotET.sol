contract KotET{
    address public king;
    uint public claimPrice = 100;
    address owner;


    function sweepCommission(uint amount){
        owner.send(amount);
    }

    function winKing() payable {
        require(msg.value < claimPrice);
        uint compensation = 10;
        king.send(compensation);
        king = msg.sender;
        claimPrice = 1;
    }
}