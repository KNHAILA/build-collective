pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

import "./Ownable.sol";

contract BuildCollective is Ownable {
  struct User {
    string username;
    uint256 balance;
    bool registered;
  }
  
  struct Enterprise {
    string name;
    address user;
    address[] membersAddress;
    uint256 balance;
  }

  address[] public userAddresses;
  uint256 internal ProjectId;

  struct Project {
    uint256 id;
    string name;
    string link;
    address owner; 
    bool ownedByUser;
    address[] contributorsList;
    uint256 balance;
  }

  mapping(address => User) private users;
  mapping(address => Enterprise) private enterprises;
  mapping(address => Project[]) private projects;

  event UserSignedUp(address indexed userAddress, User indexed user);
  event RegisterEnterprise(address indexed ownerAddress, Enterprise indexed enterprise);
  event ProjectCreate(address indexed ownerAddress, Project indexed project);
  
  function getUser(address userAddress) public view returns (User memory) {
    require(users[userAddress].registered);
    return users[userAddress];
  }

  function getAllUsers() external view returns (address[] memory) {
    return userAddresses;
  }

  function getEnterprise(address enterpriseAddress) public view returns (Enterprise memory) {
    require(users[enterpriseAddress].registered);
    return enterprises[enterpriseAddress];
  }

  function getProject(address ownerAddress) public view returns (Project[] memory){
    require(users[ownerAddress].registered);
    return projects[ownerAddress];
  }

  function signUp(string memory username, uint256 amount) public returns (User memory) {
    require(bytes(username).length > 0);
    users[msg.sender] = User(username, amount, true);
    emit UserSignedUp(msg.sender, users[msg.sender]);
    userAddresses.push(msg.sender);
    return users[msg.sender];
  }

  function registerEnterprise(string memory name, address[] memory address_members, uint256 amount) public returns (Enterprise memory) {
    require(bytes(name).length > 0);
    require(users[msg.sender].registered);
    enterprises[msg.sender] = Enterprise(name, msg.sender, address_members, amount);
    emit RegisterEnterprise(msg.sender, enterprises[msg.sender]);
    return enterprises[msg.sender];
  }

  function projectCreate(string memory name, string memory link, bool ownedByUser, address[] memory contributorsList, uint256 amount) public returns (Project memory){
    require(users[msg.sender].registered);
    require(bytes(name).length > 0);
    ProjectId ++;
    Project memory project = Project(ProjectId, name, link, msg.sender, ownedByUser, contributorsList, amount);
    projects[msg.sender].push(project);
    emit ProjectCreate(msg.sender, project);
    return project;
  }

  function addBalance(uint256 amount) public returns (bool) {
    require(users[msg.sender].registered);
    users[msg.sender].balance += amount;
    return true;
  }

  function transfer(address payable payee, uint256 amount) public payable returns (bool){
    bool success = payee.send(amount);
    return success;
  }

  function () external payable{}
}
