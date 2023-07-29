// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script} from "lib/forge-std/src/Script.sol";
import {MoodNft} from "../src/MoodNft.sol";
import {Base64} from "lib/openzeppelin-contracts/contracts/utils/Base64.sol";

contract DeployMoodNft is Script {
    function run() external returns (MoodNft) {
        // raw svg bytes, needs to be converted to URI using svgToImageUri() function
        string memory sadSvg = vm.readFile("./img/sad.svg");
        string memory happySvg = vm.readFile("./img/happy.svg");

        vm.startBroadcast();

        MoodNft moodNft = new MoodNft(
            svgToImageUri(sadSvg),
            svgToImageUri(happySvg)
        );

        vm.stopBroadcast();

        return moodNft;
    }

    function svgToImageUri(
        string memory svg
    ) public pure returns (string memory) {
        string memory baseUrl = "data:image/svg+xml;base64,";
        string memory svgBase64Encoded = Base64.encode(
            bytes(string(abi.encodePacked(svg)))
        );

        return string(abi.encodePacked(baseUrl, svgBase64Encoded));
    }
}
