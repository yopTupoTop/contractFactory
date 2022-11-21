pragma solidity ^0.8.12;

import "contracts/My1155.sol";
import "contracts/My721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ContractFactory is Ownable {
    
    string private _erc721BaseUri;
    string private _erc1155BaseUri;

    My1155[] private my1155tokens;
    My721[] private my721tokens;

    mapping(uint256 => address) private my1155indexToContract; //index to 1155 contract address
    mapping(uint256 => address) private my1155indexToOwner; //index to 1155 contract owner

    mapping(uint256 => address) private my721indexToContract; // index to 721 contract address
    mapping(uint256 => address) private my721indexToOwner; // index to 721 contract owner

    event ERC721deployed(address owner, address contractAddress);
    event ERC721minted(address owner);

    event ERC1155deployed(address owner, address contractAddress);
    event ERC1155minted(address owner, uint256 tokenId, uint256 amount);

    constructor(string memory erc721BaseUri, string memory erc1155BaseUri) {
        _erc721BaseUri = erc721BaseUri;
        _erc1155BaseUri = erc1155BaseUri;
    }

    function deployERC721() external onlyOwner returns (address) {
        My721 my721 = new My721(_erc721BaseUri);
        my721tokens.push(my721);
        my721indexToContract[my721tokens.length - 1] = address(my721);
        my721indexToOwner[my721tokens.length - 1] = tx.origin;
        emit ERC721deployed(tx.origin, address(my721));
        return address(my721);
    }

    function deployERC1155() external onlyOwner returns (address) {
        My1155 my1155 = new My1155(_erc1155BaseUri);
        my1155tokens.push(my1155);
        my1155indexToContract[my1155tokens.length - 1] = address(my1155);
        my1155indexToOwner[my1155tokens.length - 1] = tx.origin;
        emit ERC1155deployed(tx.origin, address(my1155));
        return address(my1155);
    }

    function mintERC721(uint256 index) external onlyOwner {
        my721tokens[index].mint(my721indexToOwner[index]);
        emit ERC721minted(my721indexToOwner[index]);
    }

    function mintERC1155(uint256 index, uint256 tokenId, uint256 amount) external onlyOwner {
        my1155tokens[index].mint(my1155indexToOwner[index], tokenId, amount);
        emit ERC1155minted(my1155indexToOwner[index], tokenId, amount);
    }
}