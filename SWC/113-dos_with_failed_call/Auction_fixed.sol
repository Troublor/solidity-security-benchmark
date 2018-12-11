contract Auction{
	address public currentLeader;
	uint256 public highestBid;



	function bid() public payable{
	    require(msg.sender.call.value(10)());
		//require(msg.value > highestBid);
		//require(currentLeader.send(highestBid));
		currentLeader = msg.sender;
		highestBid = uint256(currentLeader);
	}
}