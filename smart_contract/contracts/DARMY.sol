// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MyToken is ERC721 {
    address public admin;
    uint256 public totalSupply;
    mapping(address => uint256) public permanentTokenBalances; // Permanent Token balances
    mapping(address => uint256) public purchaseTokenBalances; // Purchase Token balances
    mapping(address => string) public fanGrades; // User fan grades mapping
    mapping(uint256 => address) public ticketOwners; // Ticket ownership mapping
    mapping(address => uint256[]) public userTickets; // Mapping to store token IDs for each user

    // Minimum token balances for each grade
    uint256 public challengerThreshold;   // Minimum token balance for Challenger grade
    uint256 public masterThreshold;       // Minimum token balance for Master grade
    uint256 public diamondThreshold;      // Minimum token balance for Diamond grade
    uint256 public platinumThreshold;     // Minimum token balance for Platinum grade
    uint256 public goldThreshold;         // Minimum token balance for Gold grade
    uint256 public silverThreshold;       // Minimum token balance for Silver grade
    uint256 public bronzeThreshold;       // Minimum token balance for Bronze grade
    uint256 public ironThreshold;         // Minimum token balance for Iron grade

    // Grade events
    event GradeUpdated(address indexed user, string grade);
    event TokenCheckedIn(address indexed user, uint256 permanentTokenBalance, uint256 purchaseTokenBalance);
    event TicketPurchased(address indexed user, uint256 tokenId);

    constructor() ERC721("MyToken", "MTK") {
        admin = msg.sender;
        totalSupply = 1000;

        // Initialize minimum token balances for each grade
        challengerThreshold = 100;
        masterThreshold = 80;
        diamondThreshold = 60;
        platinumThreshold = 40;
        goldThreshold = 30;
        silverThreshold = 20;
        bronzeThreshold = 10;
        ironThreshold = 0;
    }

    // Check-in function
    function checkIn() external {
        // Update permanent token balance
        permanentTokenBalances[msg.sender]++;

        // Update purchase token balance
        purchaseTokenBalances[msg.sender]++;

        // Update grade
        updateGrade(msg.sender);

        emit TokenCheckedIn(msg.sender, permanentTokenBalances[msg.sender], purchaseTokenBalances[msg.sender]);
    }

    // Update grade function
    function updateGrade(address user) internal {
        if (permanentTokenBalances[user] >= challengerThreshold) {
            fanGrades[user] = "Challenger";
        } else if (permanentTokenBalances[user] >= masterThreshold) {
            fanGrades[user] = "Master";
        } else if (permanentTokenBalances[user] >= diamondThreshold) {
            fanGrades[user] = "Diamond";
        } else if (permanentTokenBalances[user] >= platinumThreshold) {
            fanGrades[user] = "Platinum";
        } else if (permanentTokenBalances[user] >= goldThreshold) {
            fanGrades[user] = "Gold";
        } else if (permanentTokenBalances[user] >= silverThreshold) {
            fanGrades[user] = "Silver";
        } else if (permanentTokenBalances[user] >= bronzeThreshold) {
            fanGrades[user] = "Bronze";
        } else {
            fanGrades[user] = "Iron";
        }

        emit GradeUpdated(user, fanGrades[user]);
    }

    // Buy Premium Ticket function from merchandise shop
    function buyPremiumTicket() external {
        require(
            keccak256(bytes(fanGrades[msg.sender])) == keccak256(bytes("Challenger")) ||
            keccak256(bytes(fanGrades[msg.sender])) == keccak256(bytes("Master")) ||
            keccak256(bytes(fanGrades[msg.sender])) == keccak256(bytes("Diamond")),
            "You are not eligible to buy premium tickets"
        );

        // Consume Purchase Token
        require(purchaseTokenBalances[msg.sender] >= 100, "Insufficient purchase tokens");
        purchaseTokenBalances[msg.sender] -= 100;

        // Update grade
        updateGrade(msg.sender);

        // Mint NFT ticket
        uint256 tokenId = totalSupply + 1;
        _safeMint(msg.sender, tokenId);
        totalSupply++;

        // Update ticket ownership
        ticketOwners[tokenId] = msg.sender;

        // Store token ID for the user
        userTickets[msg.sender].push(tokenId);

        emit TicketPurchased(msg.sender, tokenId);
    }

    // Give 10 tokens function
    function give10tokens() external {
        // Update permanent token balance
        permanentTokenBalances[msg.sender] += 10;

        // Update purchase token balance
        purchaseTokenBalances[msg.sender] += 10;

        // Update grade
        updateGrade(msg.sender);
    }

    // Give 100 tokens function
    function give100tokens() external {
        // Update permanent token balance
        permanentTokenBalances[msg.sender] += 100;

        // Update purchase token balance
        purchaseTokenBalances[msg.sender] += 100;

        // Update grade
        updateGrade(msg.sender);
    }

    // Get the owner of a ticket
    function getTicketOwner(uint256 tokenId) external view returns (address) {
        require(_exists(tokenId), "Ticket does not exist");
        return ownerOf(tokenId);
    }
    
    // Get user's tickets
    function getUserTickets(address user) external view returns (uint256[] memory) {
        return userTickets[user];
    }
}
