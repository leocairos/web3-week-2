// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

struct Tweet {
    address author;
    string text;
    uint timestamp;
    string username;
    string avatar;
}

contract CrypTwitter {

    address private owner;

    uint public nextId = 0;

    uint public pageSize = 10;

    mapping(uint => Tweet) public tweets;

    mapping(address => string) public users;
    mapping(address => string) public avatars;

    constructor() {   
        owner=msg.sender;
    }
  
    function getOwner() public view returns (address) {    
        return owner;
    }
    
    function setPageSize(uint newPageSize) public {    
        require(msg.sender == owner, "You do not have permission");
        if(newPageSize < 1) newPageSize = 10;       
        pageSize = newPageSize;
    }

    function addTweet(string calldata text) public {
        Tweet memory newTweet;
        newTweet.text = text;
        newTweet.author = msg.sender;
        newTweet.timestamp = block.timestamp;

        nextId++;
        tweets[nextId] = newTweet;
    }

    function changeUsername(string calldata newName) public {
        users[msg.sender] = newName;
    }

    function changeAvatar(string calldata avatarURL) public {
        avatars[msg.sender] = avatarURL;
    }

    function getLastTweets(uint page) public view returns (Tweet[] memory) {
        if(page < 1) page = 1;
        uint startIndex = (pageSize * (page - 1)) + 1;

        Tweet[] memory lastTweets = new Tweet[](pageSize);
        for(uint i=0; i < pageSize; i++){
            lastTweets[i] = tweets[startIndex + i];
            lastTweets[i].username = users[lastTweets[i].author];
            lastTweets[i].avatar = avatars[lastTweets[i].author];
        }

        return lastTweets;
    
    }

}