pragma solidity ^0.4.24;

//Based on the the Capture the Ether challange at https://capturetheether.com/challenges/lotteries/predict-the-block-hash/
//Note that while it seems to have a 1/2^256 chance you guess the right hash, actually blockhash returns zero for blocks numbers that are more than 256 blocks ago so you can guess zero and wait.
contract PredictTheBlockHashChallenge {


      uint commitblock;
      bytes32 guess;


    constructor() public payable {
        require(msg.value == 1 ether);
    }

    function lockInGuess(bytes32 hash) public payable {
        require(commitblock == 0);
        require(msg.value == 1 ether);

        guess = hash;
        commitblock  = block.number + 1;
    }

    function settle() public {
        require(block.number > commitblock+10);
        //Note that this solution prevents the attack where blockhash(guesses[msg.sender].block) is zero
        //Also we add ten block cooldown period so that a minner cannot use foreknowlege of next blockhashes
        require(block.number - commitblock < 256);

          bytes32 answer = blockhash(commitblock);

          commitblock = 0;
          if (guess == answer) {
              msg.sender.transfer(2 ether);
          }

    }
}
