// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ProductVerification {
    struct Product {
        address manufacturer;
        string name;
        uint256 manufactureDate;
        bool isVerified;
        address currentOwner;
    }

    mapping(bytes32 => Product) public products;
    mapping(address => bool) public manufacturers;

    address[] public manufacturerAddresses; 
    bytes32[] public productIds;            

    event ProductRegistered(bytes32 productId, string name, address manufacturer);
    event OwnershipTransferred(bytes32 productId, address from, address to);
    event FakeProductReported(bytes32 productId, address reporter);
    event ManufacturerAdded(address manufacturer); 
    modifier onlyManufacturer() {
        require(manufacturers[msg.sender], "Only registered manufacturers can call this function");
        _;
    }

    function registerManufacturer(address _manufacturer) public {
        require(!manufacturers[_manufacturer], "Manufacturer already registered");

        manufacturers[_manufacturer] = true;
        manufacturerAddresses.push(_manufacturer); 
        emit ManufacturerAdded(_manufacturer); 
    }

    function registerProduct(string memory _name, bytes32 _productId) public onlyManufacturer {
        require(products[_productId].manufacturer == address(0), "Product already registered");

        products[_productId] = Product({
            manufacturer: msg.sender,
            name: _name,
            manufactureDate: block.timestamp,
            isVerified: true,
            currentOwner: msg.sender
        });

        productIds.push(_productId); 

        emit ProductRegistered(_productId, _name, msg.sender);
    }

    function verifyProduct(bytes32 _productId) public view returns (bool, string memory, address) {
        Product memory product = products[_productId];
        return (product.isVerified, product.name, product.manufacturer);
    }

    function transferOwnership(bytes32 _productId, address _newOwner) public {
        require(products[_productId].currentOwner == msg.sender, "Only the current owner can transfer ownership");
        products[_productId].currentOwner = _newOwner;
        emit OwnershipTransferred(_productId, msg.sender, _newOwner);
    }

    function reportFakeProduct(bytes32 _productId) public {
        require(products[_productId].isVerified, "Product not found or already reported as fake");
        products[_productId].isVerified = false;
        emit FakeProductReported(_productId, msg.sender);
    }

    function getManufacturerDetails() public view returns (uint256, address[] memory) {
        return (manufacturerAddresses.length, manufacturerAddresses);
    }

    function getProductDetails() public view returns (uint256, bytes32[] memory) {
        return (productIds.length, productIds);
    }

    function getProductById(bytes32 _productId) public view returns (string memory, address, uint256, bool, address) {
        Product memory product = products[_productId];
        return (
            product.name,
            product.manufacturer,
            product.manufactureDate,
            product.isVerified,
            product.currentOwner
        );
    }
}
