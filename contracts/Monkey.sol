// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract Monkey is Ownable, ERC721Enumerable, ERC721URIStorage {
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    event Minted(address indexed owner, uint256 indexed tokenId, string tokenURI);

    mapping(uint256 => uint256) public tokenIdToLevels;
    mapping(uint256 => string) public tokenIdToNames;
    mapping(uint256 => string) public tokenIdToBirth;
    mapping(uint256 => uint256) public tokenIdToListen;
    mapping(uint256 => string) public tokenIdToTestDates;
    mapping(uint256 => string) public tokenIdToExpirationDates;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {}

    function generateCharacter() public pure returns (string memory) {
        return "https://github.com/cool14412/aaa/blob/main/25321-removebg-preview.png?raw=true";
    }

    function getTokenURI(uint256 tokenId) public view returns (string memory) {
        bytes memory dataURI = abi.encodePacked(
            "{",
            '"name": "TOEIC #',
            tokenId.toString(),
            '",',
            '"description": "\\ud1a0\\uc775(Test of English for International Communication) \\uc778\\uc99d\\uc11c\\ub85c, [\\ubc1c\\ud589 \\uae30\\uad00]\\uc5d0\\uc11c \\uc778\\uc99d\\ub429\\ub2c8\\ub2e4. \\uc774 \\uc778\\uc99d\\uc11c\\uc758 \\uc18c\\uc720\\uc790\\uc5d0\\uac8c\\ub294 \\uc601\\uc6d0\\ud55c \\uc18c\\uc7ac \\ubc0f \\uac70\\ub798 \\uac00\\ub2a5\\ud55c \\ud22c\\uba85\\ud55c \\uc778\\uc99d \\ubc29\\uc2dd\\uc744 \\uc81c\\uacf5\\ud569\\ub2c8\\ub2e4. \\uad6c\\ub9e4\\uc790\\ub294 \\uc774 NFT\\ub97c \\ud1b5\\ud574 \\uc5bb\\uc740 \\ud1a0\\uc775 \\uc810\\uc218\\ub97c \\uc62c\\ubc14\\ub974\\uac8c \\uc0ac\\uc6a9\\ud560 \\uad8c\\ub9ac\\uac00 \\uc788\\uc2b5\\ub2c8\\ub2e4.",',
            '"image": "',
            generateCharacter(),
            '",',
            '"attributes": [',
            '{"trait_type": "Level", "value": ',
            tokenIdToLevels[tokenId].toString(),
            '},',
            '{"trait_type": "Name", "value": "', tokenIdToNames[tokenId], '"},',
            '{"trait_type": "Birth", "value": "', tokenIdToBirth[tokenId], '"},',
            '{"trait_type": "TOEIC Score", "value": "', tokenIdToListen[tokenId].toString(), '"},',
            '{"trait_type": "Test Date", "value": "', tokenIdToTestDates[tokenId], '"},',
            '{"trait_type": "Expiration Date", "value": "', tokenIdToExpirationDates[tokenId], '"}',
            ']',
            "}"
        );
        return string(abi.encodePacked("data:application/json;base64,", Base64.encode(dataURI)));
    }

    function mint(string memory name, string memory birth, uint256 listen, string memory testDate, string memory expirationDate) external {
        _tokenIds.increment();
        uint256 tokenId = _tokenIds.current();
        _safeMint(msg.sender, tokenId);
        tokenIdToLevels[tokenId] = 1;
        tokenIdToNames[tokenId] = name;
        tokenIdToBirth[tokenId] = birth;
        tokenIdToListen[tokenId] = listen;
        tokenIdToTestDates[tokenId] = testDate;
        tokenIdToExpirationDates[tokenId] = expirationDate;

        // Emit the Minted event with the updated token URI
        emit Minted(msg.sender, tokenId, getTokenURI(tokenId));
    }

    function _beforeTokenTransfer(address from, address to, uint256 firstTokenId, uint256 batchSize) internal virtual override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, firstTokenId, batchSize);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721URIStorage, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function _burn(uint256 tokenId) internal virtual override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId) public view virtual override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }
}