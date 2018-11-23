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
    mapping(address => address[]) addrToWatches; // mapping a user address to all the users' address he or she watched

    modifier validName(string memory _name) {
        
        // require a valid name, the length of a name must greater than 2
        require(bytes(_name).length > 2, "the length of a name must greater than 2");

        // ok
        _;
    }

    modifier newName(string memory _name) {

        // require a new name, the address of the name must be 0x0 (otherwise, means duplicate name).
        require(nameToAddr[_name] == address(0), "this name has been used."); 

        // ok
        _;
    }

    modifier existName(string memory _name) {
        
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

    function register(string memory _name) public 
        validName(_name)
        newName(_name)
        registerOnce(msg.sender) returns(bool) {

        // add a new user        
        users.push(User(_name, "", "", "", ""));
        nameToAddr[_name] = msg.sender;
        addrToUser[msg.sender] = User(_name, "", "", "", "");

        return true;
    }

    // no need to login
    // because using msg.sender to authenticate is enough, so we don' need password.

    function watch(string memory _name) public 
        registered(msg.sender)
        existName(_name) {

        // to watch a user
        address toWatch = nameToAddr[_name];
        addrToWatches[msg.sender].push(toWatch);
    }

    function unwatch(string memory _name) public
        registered(msg.sender)
        existName(_name) {

        // to unwatch a user
        address toUnwatch = nameToAddr[_name];
        uint length = addrToWatches[msg.sender].length;
        for (uint i = 0; i < length; i++) {

            address watched = addrToWatches[msg.sender][i];
            
            if (watched == address(0)) {
                // skip the invalid address
                continue;
            }

            if (toUnwatch == watched) {
                // remove the user who name _name from watched
                delete addrToWatches[msg.sender][i];
                break;
            }
        }
    }

    function getUserByIndex(uint _index) public view returns(string memory, string memory, string memory, string memory, string memory) {

        require(_index < getUserCount(), "index out of bound");

        User memory user = users[_index];
        return (user.name, user.head_img, user.moto, user.hobby, user.birthday);
    }

    // function getAllUsers() public view returns(address[] memory) {

    //     address[] memory result;
    //     for (uint i = 0; i < getWatchesCount(); i++) {
    //         address temp = getWatchesByIndex(i);
    //         if (temp == address(0)) {
    //             // skip the empty one
    //             continue;
    //         }
    //         result.push(temp);
    //     }
    //     return result;
    // }

    function getUserCount() public view returns(uint) {

        return users.length;
    }

    function getWatchesByIndex(uint _index) public view returns(address) {
        
        require(_index < getWatchesCount(), "index out of bound");

        return addrToWatches[msg.sender][_index];
    }

    // function getAllWatches() public view returns(address[] memory) {

    //     address[] memory result;
    //     for (uint i = 0; i < getWatchesCount(); i++) {
    //         address temp = getWatchesByIndex(i);
    //         if (temp == address(0)) {
    //             // skip the empty one
    //             continue;d
    //         }
    //         result.push(temp);
    //     }
    //     return result;
    // }

    function getWatchesCount() public view returns(uint) {

        return addrToWatches[msg.sender].length;
    }

    function getAddrByName(string memory _name) public view returns(address) {

        return nameToAddr[_name];
    }

    function getNameByAddr(address addr) public view returns(string memory) {

        User memory user = addrToUser[addr];
        return user.name;
    }
}
