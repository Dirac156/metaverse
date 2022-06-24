// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// impoort external token for nft

import "@openzeppelin/contracts@4.4.2/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.4.2/access/Ownable.sol";
import "@openzeppelin/contracts@4.4.2/utils/Counters.sol";

// creation of the Metaverse Smart Contract With NFT Tokens

contract Metaverse is ERC721, Ownable {

    // Counstructor: create nft tokens  name, symbol
    constructor() ERC721("META", "MJG"){}

    // use smart contracts we imported
    // counters to regulate the current amount of NFT Tokens minted

        // Establish the library
    using Counters for Counters.Counter;
        // count and regulate the supply of NFT's
    Counters.Counter private supply;

    // Totoal number of NFT available for creation
    uint256 public maxSupply = 100;

    // cost of a NFT: cost to be paid for each NFT Token
    uint256 public cost = 0.01 ether;

    // Metaverse buildings

    struct Building {
        string name; 
        int8 w; // width
        int8 h; // height
        int8 d; // deepth
        int8 x; // x axis
        int8 y; // y axis
        int8 z; // z axis
    }

    // List of Metaverse buildings
    Building[] public buildings;

    // Owner and its properties in the Metaverse
    mapping( address => Building[]) NFTOwners;

    // Obtaining the buildings made in the metaverse

    // can also use Buildinds function
    function getBuildings() public view returns (Building[] memory) {
        return buildings;
    }

    // Current supply of NFT Tokens
    function totoalSupply() public view returns(uint256) {
        return supply.current();
    }

    // Creation of the Buildings as NFT Token in the Metaverse
    function mint(string memory _building_name, int8 _w, int8 _h, 
        int8 _d, int8 _x, int8 _y, int8 _z) public payable{
            // make sure the 
            require(supply.current() <= maxSupply, "Max supply exceeded!");
            require(msg.value >= cost, "Insufficient funds!");

            supply.increment();
            // let us execute the minting of the nft token
            // assign token to the sender
            _safeMint(msg.sender, supply.current());
            Building memory _newBuild = Building(_building_name, _w, _h, _d, _x, _y, _z);

            buildings.push(_newBuild);
            NFTOwners[msg.sender].push(_newBuild);
    }

    // Extract of ethers from the smart contract to the Owner (Our wallet)
    // onlyOwner is a modifier: from imported file access/owner
    function withdraw() external payable onlyOwner {
        address payable _owner = payable(owner());
        _owner.transfer(address(this).balance);
    }

    // Obtain a user's Metaverse building
    function getOwnerBuildings() public view returns (Building [] memory) {
        return NFTOwners[msg.sender];
    }
}