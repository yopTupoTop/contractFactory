pragma solidity ^0.8.12;

import "contracts/My1155.sol";
import "contracts/My721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ERC721ContractFactory is Ownable {
    
    string private _erc721BaseUri;

    My721[] private my721tokens;

    mapping(uint256 => address) private my721indexToContract; // index to 721 contract address
    mapping(uint256 => address) private my721indexToOwner; // index to 721 contract owner

    event ERC721deployed(address owner, address contractAddress);
    event ERC721minted(address owner);
    
    constructor(string memory baseUri) {
        _erc721BaseUri = baseUri;
    }

    function deployERC721() external onlyOwner returns (address) {
        My721 my721 = new My721(_erc721BaseUri);
        my721tokens.push(my721);
        my721indexToContract[my721tokens.length - 1] = address(my721);
        my721indexToOwner[my721tokens.length - 1] = tx.origin;
        emit ERC721deployed(tx.origin, address(my721));
        return address(my721);
    }

    function mintERC721(uint256 index) external onlyOwner {
        my721tokens[index].mint(my721indexToOwner[index]);
        emit ERC721minted(my721indexToOwner[index]);
    }
}