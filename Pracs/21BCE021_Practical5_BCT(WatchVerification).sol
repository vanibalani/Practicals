// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract WatchVerification {
    
    address public owner;

    struct WatchType {
        string[] validMaterials;      
        uint minWeight;               
        string[] validMovements;     
    }
    
    struct Watch {
        string serialNumber;
        string material;
        uint weight;
        string movementType;
        string manufacturer;
        bool isVerified;
        address currentOwner;
        uint manufacturingDate;
        string priceRange;
        string[] certifications;
    }

    mapping(string => Watch) public watches;

    mapping(string => WatchType) public manufacturerWatchTypes; 

    event WatchVerified(string serialNumber, bool isVerified);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event CertificationAdded(string serialNumber, string certification);
    event WatchRegistered(string serialNumber, string manufacturer, bool isVerified);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can execute this function");
        _;
    }

    constructor() {
        owner = msg.sender;

        addManufacturerWatchType("Swiss Ltd", createMaterialArray("Gold", "Silver", "Platinum"), 200, createMovementArray("Mechanical", "Quartz"));
        addManufacturerWatchType("Rolex", createMaterialArray("Gold", "Silver", "Titanium"), 180, createMovementArray("Mechanical","Digital"));
        addManufacturerWatchType("Casio", createMaterialArray("Plastic", "Rubber", "Steel"), 100, createMovementArray("Quartz", "Digital"));
    }

    function createMaterialArray(string memory mat1, string memory mat2, string memory mat3) internal pure returns (string[] memory) {
        string[] memory materials = new string[](3);
        materials[0] = mat1;
        materials[1] = mat2;
        materials[2] = mat3;
        return materials;
}

    function createMovementArray(string memory move1, string memory move2) internal pure returns (string[] memory) {
        string[] memory movements = new string[](2);
        movements[0] = move1;
        movements[1] = move2;
        return movements;
    }

    function transferContractOwnership(address _newOwner) public onlyOwner {
        require(_newOwner != address(0), "Invalid new owner address");
        emit OwnershipTransferred(owner, _newOwner);
        owner = _newOwner;
    }
    
    function addManufacturerWatchType(
        string memory _manufacturer,
        string[] memory _validMaterials,
        uint _minWeight,
        string[] memory _validMovements
    ) public onlyOwner {
        require(bytes(_manufacturer).length > 0, "Manufacturer name cannot be empty");

        WatchType memory newWatchType = WatchType({
            validMaterials: _validMaterials,
            minWeight: _minWeight,
            validMovements: _validMovements
        });
        
        manufacturerWatchTypes[_manufacturer] = newWatchType;
    }

    function registerWatch(
        string memory _serialNumber,
        string memory _material,
        uint _weight,
        string memory _movementType,
        string memory _manufacturer,
        uint _manufacturingDate,
        string memory _priceRange
    ) public onlyOwner {
        require(bytes(watches[_serialNumber].serialNumber).length == 0, "Watch already registered");
        require(bytes(manufacturerWatchTypes[_manufacturer].validMaterials[0]).length > 0, "Manufacturer not found");
        
        string[] memory emptyArray;

        Watch memory newWatch = Watch({
            serialNumber: _serialNumber,
            material: _material,
            weight: _weight,
            movementType: _movementType,
            manufacturer: _manufacturer,
            isVerified: false,
            currentOwner: msg.sender,
            manufacturingDate: _manufacturingDate,
            priceRange: _priceRange,
            certifications: emptyArray
        });

        watches[_serialNumber] = newWatch;
        verifyWatch(_serialNumber);
    }
    
    function verifyWatch(string memory _serialNumber) internal {
        Watch storage watch = watches[_serialNumber];
        WatchType storage manufacturerType = manufacturerWatchTypes[watch.manufacturer];
        
        bool materialValid = false;
        for (uint i = 0; i < manufacturerType.validMaterials.length; i++) {
            if (keccak256(abi.encodePacked(watch.material)) == keccak256(abi.encodePacked(manufacturerType.validMaterials[i]))) {
                materialValid = true;
                break;
            }
        }

        bool movementValid = false;
        for (uint i = 0; i < manufacturerType.validMovements.length; i++) {
            if (keccak256(abi.encodePacked(watch.movementType)) == keccak256(abi.encodePacked(manufacturerType.validMovements[i]))) {
                movementValid = true;
                break;
            }
        }

        if (materialValid && movementValid && watch.weight >= manufacturerType.minWeight) {
            watch.isVerified = true;
        } else {
            watch.isVerified = false;
        }
        
        emit WatchVerified(watch.serialNumber, watch.isVerified);
    }

    function transferWatchOwnership(string memory _serialNumber, address _newOwner) public onlyOwner {
        Watch storage watch = watches[_serialNumber];
        emit WatchRegistered(_serialNumber, watch.manufacturer, watch.isVerified);
        watch.currentOwner = _newOwner;
    }
    
    function addCertification(string memory _serialNumber, string memory _certification) public onlyOwner {
        Watch storage watch = watches[_serialNumber];
        watch.certifications.push(_certification);
        emit CertificationAdded(_serialNumber, _certification);
    }
    
    function getVerificationStatus(string memory _serialNumber) public view returns (bool) {
        Watch storage watch = watches[_serialNumber];
        return watch.isVerified;
    }
    
    function getWatchDetails(string memory _serialNumber) public view returns (
        string memory, string memory, uint, string memory, string memory, bool, address, uint, string memory, string[] memory
    ) {
        Watch storage watch = watches[_serialNumber];
        return (
            watch.serialNumber,
            watch.material,
            watch.weight,
            watch.movementType,
            watch.manufacturer,
            watch.isVerified,
            watch.currentOwner,
            watch.manufacturingDate,
            watch.priceRange,
            watch.certifications
        );
    }
}
