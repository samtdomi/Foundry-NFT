//SPDX-License-Identifier: MIT

/*    Pragma Statements    */
pragma solidity ^0.8.19;

/* Import declarations */
import {ERC721} from "lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import {Base64} from "lib/openzeppelin-contracts/contracts/utils/Base64.sol";

/*    Error declarations */

/*    Contracts, Libraries, Interfaces    */
contract MoodNft is ERC721 {
    /*    Type Declarations    */
    enum Mood {
        Happy,
        Sad
    }
    Mood private mood;

    /*    State Varaibles    */
    uint256 private s_tokenCounter;
    string private s_sadSvgImageUr;
    string private s_happySvgImageUri;
    mapping(uint256 => Mood) private s_tokenIdToMood;

    /*    Events    */

    /*    Modifiers    */

    /*    Functions    */
    constructor(
        string memory sadSvgImageUri,
        string memory happySvgImageUri
    ) ERC721("Mood NFT", "MN") {
        s_tokenCounter = 0;
        s_sadSvgImageUri = sadSvgImageUri;
        s_happySvgImageUri = happySvgImageUri;
    }

    function mintNft() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdToMood[s_tokenCounter] = Mood.Happy;
        s_tokenCounter++;
    }

    function flipMood(uint256 tokenId) public {
        // only want the NFT owner to be able to change the mood
        if (!_isApprovedOrOwner(msg.sender, tokenId)) {
            revert;
        }
        // flip the mood
        if (s_tokenIdToMood[tokenId] == Mood.Happy) {
            s_tokenIdToMood[tokenId] = Mood.Sad;
        } else {
            s_tokenIdToMood[tokenId] = Mood.Happy;
        }
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        string memory imageUri;

        if (s_tokenIdToMood[tokenId] == Mood.Happy) {
            imageUri = s_happySvgImageUri;
        } else {
            imageUri = s_sadSvgImageUri;
        }

        return
            string(
                abi.encodePacked(
                    _baseURI(),
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name": "',
                                name(),
                                '", "description": "An NFT that reflects the owners mood.", "attributes": [{"trait_type": "moodiness", "value": 100}], "image": "',
                                imageUri,
                                '"}'
                            )
                        )
                    )
                )
            );
    }
}
