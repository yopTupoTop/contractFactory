pragma solidity ^0.8.12;

import "contracts/My1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ERC1155ContractFactory is Ownable {
    string private _erc1155BaseUri;

    My1155[] private my1155tokens;

    mapping(uint256 => address) private my1155indexToContract; //index to 1155 contract address
    mapping(uint256 => address) private my1155indexToOwner; //index to 1155 contract owner

    event ERC1155deployed(address owner, address contractAddress);
    event ERC1155minted(address owner, uint256 tokenId, uint256 amount);

    constructor(string memory baseUri) {
        _erc1155BaseUri = baseUri;
    }

    function deployERC1155() external onlyOwner returns (address) {
        My1155 my1155 = new My1155(_erc1155BaseUri);
        my1155tokens.push(my1155);
        my1155indexToContract[my1155tokens.length - 1] = address(my1155);
        my1155indexToOwner[my1155tokens.length - 1] = tx.origin;
        emit ERC1155deployed(tx.origin, address(my1155));
        return address(my1155);
    }

     function mintERC1155(uint256 index, uint256 tokenId, uint256 amount) external onlyOwner {
        my1155tokens[index].mint(my1155indexToOwner[index], tokenId, amount);
        emit ERC1155minted(my1155indexToOwner[index], tokenId, amount);
    }
}