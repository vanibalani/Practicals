// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ProductVerificationV2 {
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
    bytes32[] public fakeProductIds; 

    event ProductRegisteredV2(bytes32 productId, string name, address manufacturer); 
    event OwnershipTransferredV2(bytes32 productId, address from, address to);
    event FakeProductReportedV2(bytes32 productId, address reporter); 
    event ManufacturerAddedV2(address manufacturer); 

    function registerManufacturerV2(address _manufacturer) public {
        require(!manufacturers[_manufacturer], "Manufacturer already registered");

        manufacturers[_manufacturer] = true;
        manufacturerAddresses.push(_manufacturer);

        emit ManufacturerAddedV2(_manufacturer);
    }

    function registerProductV2(string memory _name, bytes32 _productId) public {
        require(products[_productId].manufacturer == address(0), "Product already registered");

        products[_productId] = Product({
            manufacturer: msg.sender,
            name: _name,
            manufactureDate: block.timestamp,
            isVerified: true,
            currentOwner: msg.sender
        });

        productIds.push(_productId);

        emit ProductRegisteredV2(_productId, _name, msg.sender);
    }

    function verifyProductV2(bytes32 _productId) public view returns (bool, string memory, address) {
        Product memory product = products[_productId];
        return (product.isVerified, product.name, product.manufacturer);
    }

    function transferOwnershipV2(bytes32 _productId, address _newOwner) public {
        require(products[_productId].currentOwner == msg.sender, "Only the current owner can transfer ownership");
        products[_productId].currentOwner = _newOwner;
        emit OwnershipTransferredV2(_productId, msg.sender, _newOwner);
    }

    function reportFakeProductV2(bytes32 _productId) public {
        require(products[_productId].isVerified, "Product not found or already reported as fake");
        products[_productId].isVerified = false;
        fakeProductIds.push(_productId); 
        emit FakeProductReportedV2(_productId, msg.sender);
    }

    function getNumberOfFakeProducts() public view returns (uint256) {
        return fakeProductIds.length;
    }

    function getManufacturerDetailsV2() public view returns (uint256, address[] memory) {
        return (manufacturerAddresses.length, manufacturerAddresses);
    }

    function getProductDetailsV2() public view returns (uint256, bytes32[] memory) {
        return (productIds.length, productIds);
    }
    
    function getProductByIdV2(bytes32 _productId) public view returns (string memory, address, uint256, bool, address) {
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
