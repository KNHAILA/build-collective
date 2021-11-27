pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

import "./Ownable.sol";

contract BuildCollective is Ownable {

  //User

  struct User {
    string username;
    uint256 balance;
    bool registered;
  }

  mapping(address => User) private users;
  address[] public allUsers;

  event UserSignedUp(address indexed userAddress, User indexed user);

  function user(address userAddress) public view returns (User memory) {
    return users[userAddress];
  }

  function getAllUsers() external view returns (address[] memory) {
    return allUsers;
  }

  function getUser(address userAddress) public view returns (User memory) {
    require(users[userAddress].registered);
    return users[userAddress];
  }

  function signUp(string memory username) public returns (User memory) {
    require(bytes(username).length > 0);
    users[msg.sender] = User(username, 0, true);
    emit UserSignedUp(msg.sender, users[msg.sender]);
  }

  function addBalance(uint256 amount) public returns (bool) {
    require(users[msg.sender].registered);
    users[msg.sender].balance += amount;
    return true;
  }

//enterprise

  struct Enterprise {
    string name;
    address user;
    address[] membersAddress;
    uint256 balance;
  }

  mapping(address => Enterprise) private enterprises;

  event RegisterEnterprise(address indexed ownerAddress, Enterprise indexed enterprise);

  function registerEnterprise(string memory name, address[] memory members_address, uint256 balance_) public returns (Enterprise memory) {
    require(bytes(name).length > 0);
    require(users[msg.sender].registered);
    enterprises[msg.sender] = Enterprise(name, msg.sender, members_address, balance_);
    emit RegisterEnterprise(msg.sender, enterprises[msg.sender]);
    return enterprises[msg.sender];
  }

  function getEnterprise(address enterprise_address) public view returns (Enterprise memory) {
    require(users[enterprise_address].registered);
    return enterprises[enterprise_address];
  }

}
