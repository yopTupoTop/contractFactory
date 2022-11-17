pragma solidity ^0.8.12;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract My1155 is ERC1155, Ownable {

    using Strings for uint256;

    string private _baseUri;
    string private _uriSuffix;

    constructor (string memory baseUri) ERC1155(baseUri) {
        _baseUri = baseUri;
        _uriSuffix = ".json";
    }

    function mint(address to, uint256 tokenId, uint256 amount) external onlyOwner returns (uint256) {
        _mint(to, tokenId, amount, "");
        return tokenId;
    } 

    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts) external onlyOwner {
        _mintBatch(to, ids, amounts, "");
    }

    function uri(uint256 tokenId) public view virtual override returns (string memory) {
        string memory baseUri = setURI();
        return bytes(baseUri).length > 0
            ? string.concat(baseUri, tokenId.toString(), _uriSuffix) : "";
    }

    function setURI() internal view returns (string memory){
        return _baseUri;
    }
}