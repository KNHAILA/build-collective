pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

import "./Ownable.sol";

contract BuildCollective is Ownable {

  //user

  struct User {
    string username;
    uint256 balance;
    bool registered;
  }

  address[] public userAddresses;
  mapping(address => User) private users;

  event UserSignedUp(address indexed userAddress, User indexed user);

  function getUser(address userAddress) public view returns (User memory) {
    require(users[userAddress].registered);
    return users[userAddress];
  }

  function getAllUsers() external view returns (address[] memory) {
    return userAddresses;
  }

  function signUp(string memory username, uint256 amount) public returns (User memory) {
    require(bytes(username).length > 0);
    users[msg.sender] = User(username, amount, true);
    emit UserSignedUp(msg.sender, users[msg.sender]);
    userAddresses.push(msg.sender);
    return users[msg.sender];
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

  //enterprise

  struct Enterprise {
    string name;
    address user;
    address[] membersAddress;
    uint256 balance;
  }
  
  mapping(address => Enterprise) private enterprises;
  event RegisterEnterprise(address indexed ownerAddress, Enterprise indexed enterprise);

  function getEnterprise(address enterpriseAddress) public view returns (Enterprise memory) {
    require(users[enterpriseAddress].registered);
    return enterprises[enterpriseAddress];
  }

  //In this function, we register an enterprise with a sender user. Enterprise can have one or more members.
  //The user must be already registered
  function registerEnterprise(string memory name, address[] memory address_members, uint256 amount) public returns (Enterprise memory) {
    require(bytes(name).length > 0);
    require(users[msg.sender].registered);
    enterprises[msg.sender] = Enterprise(name, msg.sender, address_members, amount);
    emit RegisterEnterprise(msg.sender, enterprises[msg.sender]);
    return enterprises[msg.sender];
  }

  //project

  uint256 internal Project_id;

  struct Project {
    uint256 id;
    string name;
    string link;
    uint256 balance;
    address owner; 
    bool ownerType; //owner type can be equal to "user" or "enterprise"
    address[] contributors;
  }

  mapping(address => Project[]) private projects;
  event CreateProject(address indexed ownerAddress, Project indexed project);

  function getProject(address ownerAddress) public view returns (Project[] memory){
    require(users[ownerAddress].registered);
    return projects[ownerAddress];
  }

  function createProject(string memory name, string memory link, uint256 amount, bool ownerType, address[] memory contributors) public returns (Project memory){
    require(users[msg.sender].registered);
    require(bytes(name).length > 0);
    Project_id = Project_id + 1;
    Project memory project = Project(Project_id, name, link, amount, msg.sender, ownerType, contributors);
    projects[msg.sender].push(project);
    emit CreateProject(msg.sender, project);
    return project;
  }

  //Bugs

  uint256 internal Bug_id;

  struct Bug {
    uint256 id;
    string title;
    string description;
    bool is_solved;
    uint256 ETH_reward;
    address payable bug_fixer;
    address bug_finder; 
    string git_link; //Link of Gitlab or Github
  }

  mapping(uint => Bug[]) private bugs;
  event CreateBug(address indexed bugFinderAddress, Bug indexed bug);

  function getBug(uint256 project_id) public view returns (Bug[] memory) {
    return bugs[project_id];
  }

  function createBug(address projectOwnerAddress, uint256 project_id, string memory title, string memory description, string memory git_link, uint256 ETH_reward) public returns (Bug memory){
    require(bytes(title).length > 0);
    require(users[projectOwnerAddress].registered);
    require(users[msg.sender].registered);
    Bug_id = Bug_id + 1;
    Bug memory bug = Bug(Bug_id, title, description, false, ETH_reward, address(0), msg.sender, git_link);
    bugs[project_id].push(bug);
    emit CreateBug(msg.sender, bug);
    return bug;
  }

  function isBugFixed(uint256 project_id, uint256 bug_id, address payable bug_fixer) public payable returns (bool){
    for (uint i = 0; i < bugs[project_id].length; i++){
      if (bugs[project_id][i].id == bug_id) {
        bugs[project_id][i].bug_fixer = bug_fixer;
        bug_fixer.transfer(bugs[project_id][i].ETH_reward);
        bugs[project_id][i].is_solved = true;
        return true;
      }
    }
    return false;
  }
}