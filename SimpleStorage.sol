// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0;

contract SimpleStorage {
    // this will get initialized to 0
    uint256  favoriteNumber;

    struct People {
        uint256 favoriteNumber;
        string name;
    }

    //dynamic array
    People[] public people;
	// mapping
    mapping(string => uint256) public nameToFavoriteNumber;

    function store(uint256 _favoriteNumber) public {
        favoriteNumber = _favoriteNumber;
    }
    // view, pure - read/action on the current state of the blockchain, no transaction
   function retrieve() public view returns(uint256) {
        return favoriteNumber;
    }

    // store in memory, only during execution, vs storage
    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        people.push(People(_favoriteNumber, _name));
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }
}
