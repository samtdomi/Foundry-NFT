//SPDX-License-Identifier: MIT

/*    Pragma Statements    */
pragma solidity ^0.8.19;

/* Import declarations */
import {ERC721} from "lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";

/*    Error declarations */

/*    Contracts, Libraries, Interfaces    */
contract BasicNft is ERC721 {
    /*    Type Declarations    */

    /*    State Varaibles    */
    uint256 private s_tokenCounter;
    mapping(uint256 => string) private s_tokenIdToUri;

    /*    Events    */

    /*    Modifiers    */

    /*    Functions    */

    // ERC721(string memory name_, string memory symbol_)
    constructor() ERC721("DOGGIE", "DOG") {
        s_tokenCounter = 0;
    }

    function mintNft(string memory tokenUri) public {
        s_tokenIdToUri[s_tokenCounter] = tokenUri;
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenCounter++;
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        // @returns  "ipfs://IPFSHASHVALUE"
        return s_tokenIdToUri[tokenId];
    }
}
