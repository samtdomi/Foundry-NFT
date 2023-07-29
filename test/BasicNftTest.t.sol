//SPDX-License-Identifier: MIT

/*    Pragma Statements    */
pragma solidity ^0.8.19;

/* Import declarations */
import {Test} from "lib/forge-std/src/Test.sol";
import {BasicNft} from "../src/BasicNft.sol";
import {DeployBasicNft} from "../script/DeployBasicNft.s.sol";

contract BasicNftTest is Test {
    /*    Type Declarations    */
    DeployBasicNft public deployBasicNft;
    BasicNft public basicNft;

    /*    State Varaibles    */
    address public user = makeAddr("user");
    string public pugUri =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    function setUp() public {
        deployBasicNft = new DeployBasicNft();
        basicNft = deployBasicNft.run();
    }

    function testNameIsCorrect() public view {
        string memory expectedName = "Doggie";
        string memory actualName = basicNft.name();
        // cannot compare strings, have to turn them in to bytes first using abi.encodePacked()
        // then put the bytes value into keccak256 hash function to get a hash value
        // assert(expectedName == actualName);
        assert(
            keccak256(abi.encodePacked(expectedName)) ==
                keccak256(abi.encodePacked(actualName))
        );
    }

    function testCanMintAndHaveABalance() public {
        vm.prank(user);
        basicNft.mint(pugUri);

        // user should have 1 nft after calling this mint function above
        assert(basicNft.balanceOf(user) == 1);
        assert(
            keccak256(abi.encodePacked(pugUri)) ==
                keccak256(abi.encodePacked(basicNft.tokenUri(0)))
        );
    }
}
