// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

struct RoundData {
    int256 answer;
    uint256 startedAt;
    uint256 updatedAt;
    uint80 answeredInRound;
}

contract Oracle is Ownable {
    string private constant _description = "Oracle";
    uint8 private constant _decimals = 18;
    uint256 private constant _version = 1;
    uint80 private _lastRoundId;
    mapping(uint80 => RoundData) private _roundData;

    event AnswerUpdated(int256 indexed current, uint256 indexed roundId, uint256 updatedAt);

    /* deciamls = 18, version = 1 */
    constructor() {}

    function description() external pure returns (string memory) {
        return _description;
    }

    function decimals() external pure returns (uint8) {
        return _decimals;
    }

    function version() external pure returns (uint256) {
        return _version;
    }

    function getRoundData(uint80 _roundId)
        external
        view
        returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound)
    {
        RoundData memory roundData = _roundData[_roundId];
        return (_roundId, roundData.answer, roundData.startedAt, roundData.updatedAt, roundData.answeredInRound);
    }

    function latestRoundData()
        external
        view
        returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound)
    {
        RoundData memory roundData = _roundData[_lastRoundId];
        return (_lastRoundId, roundData.answer, roundData.startedAt, roundData.updatedAt, roundData.answeredInRound);
    }

    function updateRoundData(RoundData memory roundData) external onlyOwner {
        _lastRoundId++;
        _roundData[_lastRoundId] = roundData;
        emit AnswerUpdated(roundData.answer, _lastRoundId, roundData.updatedAt);
    }

    function getUpdateFee(bytes[] calldata) external pure returns (uint256) {
        return 0;
    }

    function updatePriceFeeds(bytes[] calldata) external {
        // do nothing
    }
}
