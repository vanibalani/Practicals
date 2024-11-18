// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

contract Ticket {
    uint256 public ticketPrice;
    address public owner;
    mapping(address => uint256) public ticketHolders;

    event TicketsBought(address indexed user, uint256 amount, uint256 totalCost);
    event TicketsUsed(address indexed user, uint256 amount);
    event Withdrawal(uint256 amount);
    event TicketPriceUpdated(uint256 newPrice);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action.");
        _;
    }

    constructor() {
        owner = msg.sender;
        ticketPrice = 0.01 ether; // Set the ticket price directly in the constructor
    }

    function buyTickets(uint256 _amount) public payable {
        uint256 totalCost = ticketPrice * _amount;
        require(msg.value >= totalCost, "Insufficient Ether sent for tickets.");
        
        addTickets(msg.sender, _amount);
        uint256 refund = msg.value - totalCost;

        if (refund > 0) {
            (bool refunded, ) = msg.sender.call{value: refund}("");
            require(refunded, "Refund failed.");
        }

        emit TicketsBought(msg.sender, _amount, totalCost);
    }

    function useTickets(uint256 _amount) public {
        require(ticketHolders[msg.sender] >= _amount, "Not enough tickets to use.");
        ticketHolders[msg.sender] -= _amount;
        emit TicketsUsed(msg.sender, _amount);
    }

    function addTickets(address _user, uint256 _amount) internal {
        ticketHolders[_user] += _amount;
    }

    function updateTicketPrice(uint256 _newPrice) public onlyOwner {
        ticketPrice = _newPrice;
        emit TicketPriceUpdated(_newPrice);
    }

    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No balance to withdraw.");
        
        (bool success, ) = payable(owner).call{value: balance}("");
        require(success, "Withdrawal failed.");
        emit Withdrawal(balance);
    }

    function getTicketBalance(address _user) public view returns (uint256) {
        return ticketHolders[_user];
    }

    receive() external payable {
        uint256 ticketCount = msg.value / ticketPrice;
        require(ticketCount > 0, "Insufficient Ether to buy even one ticket.");

        addTickets(msg.sender, ticketCount);
        emit TicketsBought(msg.sender, ticketCount, msg.value);
        
        uint256 excess = msg.value % ticketPrice;
        if (excess > 0) {
            (bool refunded, ) = msg.sender.call{value: excess}("");
            require(refunded, "Refund of excess Ether failed.");
        }
    }
}