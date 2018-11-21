pragma solidity ^0.4.24;

contract UserManager {

    struct User {
        
        // required
        string name;   // one user one name, no password.

        // belows are optional, a brief user profile
        string head_img; // an image url
        string moto;
        string hobby;
        string birthday;
        // other attributes
    }

    User[] users;   // all the users

    mapping(address => User) addrToUser;  // mapping account address to a user
    mapping(string => address) nameToAddr;  // mapping a username to account address
    mapping(string => string[]) nameToWatches; // mapping a username to all the users' name he or she watched

    modifier validName(string _name) {
        
        // require a valid name, the length of a name must greater than 2
        require(bytes(_name).length > 2, "the length of a name must greater than 2");

        // ok
        _;
    }

    modifier newName(string _name) {

        // require a new name, the address of the name must be 0x0 (otherwise, means duplicate name).
        require(nameToAddr[_name] == address(0), "this name has been used."); 

        // ok
        _;
    }

    modifier existName(string _name) {
        
        // require a exist name, the address of the name must exist.
        require(nameToAddr[_name] != address(0), "this name is not existed."); 

        // ok
        _;
    }

    modifier registered(address _addr) {
        
        // require _addr to be registered, the length of a name must greater than 0.
        require(bytes(addrToUser[_addr].name).length > 0, "this name is not existed."); 

        // ok
        _;
    }

    modifier registerOnce(address _addr) {

        // require _addr to be not registered, the length of a name must equal to 0.
        require(bytes(addrToUser[_addr].name).length == 0, "you have registered before.");
        
        // ok
        _;
    }

    function register(string _name) public 
        validName(_name)
        newName(_name)
        registerOnce(msg.sender) returns(bool) {

        // add a new user        
        users.push(User(_name, "", "", "", ""));

        return true;
    }

    // no need to login
    // because using msg.sender to authenticate is enough, so we don' need password.

    function watch(string _name) public 
        registered(msg.sender)
        existName(_name) {

        // to watch a user
        string memory name = addrToUser[msg.sender].name;
        nameToWatches[name].push(name);
    }

    function unwatch(string _name) public
        registered(msg.sender)
        existName(_name) {

        // to unwatch a user
        string memory name = addrToUser[msg.sender].name;
        for (uint i = 0; i < nameToWatches[name].length; i++) {
            
            if (bytes(nameToWatches[name][i]).length == 0) {
                // skip the empty string
                continue;
            }

            if (keccak256(abi.encodePacked(_name)) == keccak256(abi.encodePacked(nameToWatches[name][i]))) {
                // remove the user who name _name from watched
                delete nameToWatches[name][i];
                break;
            }
        }
    }

    function getUserByIndex(uint _index) public view returns(string, string, string, string, string) {

        User memory user = users[_index];
        return (user.name, user.head_img, user.moto, user.hobby, user.birthday);
    }

    function getUserCount() public view returns(uint) {

        return users.length;
    }
}