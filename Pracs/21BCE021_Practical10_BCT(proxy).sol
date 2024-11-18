// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Proxy {
    address public owner;
    address public implementation; 

    event ImplementationChanged(address indexed oldImplementation, address indexed newImplementation);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can execute this");
        _;
    }

    constructor(address _implementation) {
        owner = msg.sender;
        implementation = _implementation;
    }

    function updateImplementation(address _newImplementation) public onlyOwner {
        require(_newImplementation != address(0), "Invalid new implementation address");
        address oldImplementation = implementation;
        implementation = _newImplementation;
        emit ImplementationChanged(oldImplementation, _newImplementation);
    }

    fallback() external payable {
        address impl = implementation;
        require(impl != address(0), "Implementation address not set");

        assembly {
            let calldataPointer := mload(0x40)
            calldatacopy(calldataPointer, 0, calldatasize())

            let result := delegatecall(gas(), impl, calldataPointer, calldatasize(), 0, 0)

            let size := returndatasize()
            returndatacopy(calldataPointer, 0, size)

            switch result
            case 0 { revert(calldataPointer, size) }
            default { return(calldataPointer, size) }
        }
    }

    receive() external payable {
    
    }
}
