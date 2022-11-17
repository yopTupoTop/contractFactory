pragma solidity ^0.8.12;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract My721 is ERC721, ERC721Enumerable, Ownable {

    using Strings for uint256;
    using Counters for Counters.Counter;

    Counters.Counter private _counter;
    
    string private _baseUri;
    string private _uriSuffix;

    constructor (string memory baseUri) ERC721("My721", "MSTO") {
        _baseUri = baseUri;
        _uriSuffix = ".json";
    }

    function mint(address to) external onlyOwner {
        _counter.increment();
        _mint(to, _counter.current());
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "URI query for nonexistent token");

        string memory baseUri = _baseURI();
        return bytes(baseUri).length > 0
            ? string.concat(baseUri, tokenId.toString(), _uriSuffix) : ""; 
    } 

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseUri;
    }
    
    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(
            ERC721,
            ERC721Enumerable
        )
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

     function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId,
        uint256 batchSize
    ) internal override(ERC721, ERC721Enumerable){
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }
}
