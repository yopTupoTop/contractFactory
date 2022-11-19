pragma solidity ^0.8.12;

import "contracts/My1155.sol";
import "contracts/My721.sol";

contract ContractFactory {
    
    string private _erc721BaseUri;
    string private _erc1155BaseUri;

    constructor(string memory erc721BaseUri, string memory erc1155BaseUri) {
        _erc721BaseUri = erc721BaseUri;
        _erc1155BaseUri = erc1155BaseUri;
    }

    function deployERC721() external returns (address) {
        My721 my721 = new My721(_erc721BaseUri);
    }

    function deployERC1155(string memory baseUri) external returns (address) {
        My1155 my1155 = new My1155(_erc1155BaseUri);
    }
}