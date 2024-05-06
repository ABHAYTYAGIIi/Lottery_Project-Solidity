// SPDX-License-Identifier: GPL-3.0
pragma solidity>=0.5.0<0.9.0;

contract lottery
{
    address public manager;
    address payable[] public participants;

    constructor()
    {
        manager=msg.sender;                         //global variable (msg.sender)used to store the address of sender
    }

    receive() external payable                      //receive is a special function and can only be used only one time in contract.
    {
        require(msg.value ==2 ether);               // require is kind of short if-else statement if the condition is satisfied then only then the next line of block will execute.
        participants.push(payable(msg.sender));     //storing the address of sender in participants named dynamic array.
    }

    function getBalance() public view returns(uint)
    {
        require(msg.sender==manager);                // the address from which the contract would deploy becomes the manager address.
        return address(this).balance;                //getting the balance of this address basically address points the participant. 
    }

    function random() public view returns(uint)
    {
        return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,participants.length)));             //this is a built-in function to generate random number used only for learning and testing purpose. 

        //NOTE: Do not use this function in any smart contract of anything for mainnet or work purpose strictly for learning purpose!!!!!!
    }

    function selectWinner() public
    {
        require(msg.sender==manager);
        require(participants.length>=3);
        uint r = random();
        address payable winner;
        uint index = r % participants.length;
        winner = participants[index];
        winner.transfer(getBalance());
        participants = new address payable[](0);                       //this method will empty the dynamic array after money transferring to winner. 
    }
}