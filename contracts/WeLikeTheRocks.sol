// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Create2.sol";

interface EtherRock {
  function sellRock (uint rockNumber, uint price) external;
  function dontSellRock (uint rockNumber) external;
  function giftRock (uint rockNumber, address receiver) external;
}

contract RockWarden is Ownable {
  function claim(uint256 id, EtherRock rocks) public onlyOwner {
    rocks.sellRock(id, type(uint256).max);
    rocks.giftRock(id, owner());
  }
}

contract WeLikeTheRocks is ERC721, Ownable {
  EtherRock public rocks = EtherRock(0x37504AE0282f5f334ED29b4548646f887977b7cC);

  using Address for address;

  string private _baseTokenURI;
  uint256 private _totalSupply;
  bytes32 private saltNonce = keccak256("We Like The Rocks");
  
  mapping(address => address) public wardens;
    
  constructor() ERC721("We Like The Rocks", "WLTR") {}
  
  function updateBaseTokenURI(string memory baseTokenURI) public onlyOwner {
    _baseTokenURI = baseTokenURI;
  }
    
  function _baseURI() internal view virtual override returns (string memory) {
    return _baseTokenURI;
  }
  
  function totalSupply() public view virtual returns (uint256) {
    return _totalSupply;
  }
    
  function wrap(uint256 id) public {
    // get warden address
    address warden = wardens[_msgSender()];
    
    // claim rock
    RockWarden(warden).claim(id, rocks);
    
    // mint wrapped rock
    _mint(_msgSender(), id);
    
    // increment supply
    _totalSupply += 1;
  }
  
  function unwrap(uint256 id) public {
    require(_msgSender() == ownerOf(id));
    
    // burn wrapped rock
    _burn(id);
    
    // decrement supply
    _totalSupply -= 1;
    
    // send rock to user
    rocks.giftRock(id, _msgSender());
  }
  
  function createWarden() public {
    bytes32 salt = keccak256(abi.encode(_msgSender(), saltNonce));
    bytes memory bytecode = abi.encodePacked(type(RockWarden).creationCode);
    address warden = Create2.deploy(0, salt, bytecode);
    require(warden != address(0), "Warden address incorrect");
    require(wardens[_msgSender()] == address(0), "Warden already created");
    wardens[_msgSender()] = warden;
  }
}