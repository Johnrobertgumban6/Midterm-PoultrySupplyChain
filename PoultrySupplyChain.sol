// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PoultrySupplyChain {

    // ==============================
    // ROLES
    // ==============================
    address public farmer;
    address public distributor;

    constructor() {
        farmer = msg.sender;
    }

    // Set distributor AFTER deployment (fix)
    function setDistributor(address _distributor) public {
        require(msg.sender == farmer, "Only farmer can set distributor");
        require(_distributor != address(0), "Invalid address");
        distributor = _distributor;
    }

    // ==============================
    // ENUM
    // ==============================
    enum Status { Created, InTransit, Delivered }

    // ==============================
    // STRUCT
    // ==============================
    struct Product {
        uint productId;
        string name;
        uint quantity;
        string origin;
        uint dateCreated;
        address currentOwner;
        Status status;
        address[] history;
    }

    // ==============================
    // STORAGE
    // ==============================
    mapping(uint => Product) public products;
    uint public productCount;

    // ==============================
    // MODIFIERS
    // ==============================
    modifier onlyFarmer() {
        require(msg.sender == farmer, "Only farmer allowed");
        _;
    }

    modifier onlyAuthorized() {
        require(
            msg.sender == farmer || msg.sender == distributor,
            "Not authorized"
        );
        _;
    }

    modifier validProduct(uint _productId) {
        require(products[_productId].productId != 0, "Product does not exist");
        _;
    }

    // ==============================
    // 1. PRODUCT REGISTRATION
    // ==============================
    function registerProduct(
        string memory _name,
        uint _quantity,
        string memory _origin
    ) public onlyFarmer {

        require(distributor != address(0), "Distributor not set yet");

        productCount++;

        Product storage newProduct = products[productCount];

        newProduct.productId = productCount;
        newProduct.name = _name;
        newProduct.quantity = _quantity;
        newProduct.origin = _origin;
        newProduct.dateCreated = block.timestamp;
        newProduct.currentOwner = farmer;
        newProduct.status = Status.Created;

        newProduct.history.push(farmer);
    }

    // ==============================
    // 4. TRANSFER OWNERSHIP
    // ==============================
    function transferOwnership(uint _productId)
        public
        onlyAuthorized
        validProduct(_productId)
    {
        Product storage product = products[_productId];

        if (msg.sender == farmer) {
            require(distributor != address(0), "Distributor not set");

            product.currentOwner = distributor;
            product.status = Status.InTransit;
            product.history.push(distributor);
        } 
        else if (msg.sender == distributor) {
            product.status = Status.Delivered;
        }
    }

    // ==============================
    // 6. DATA RETRIEVAL
    // ==============================
    function getProduct(uint _productId)
        public
        view
        validProduct(_productId)
        returns (
            uint,
            string memory,
            uint,
            string memory,
            uint,
            address,
            Status
        )
    {
        Product memory p = products[_productId];
        return (
            p.productId,
            p.name,
            p.quantity,
            p.origin,
            p.dateCreated,
            p.currentOwner,
            p.status
        );
    }

    function getHistory(uint _productId)
        public
        view
        validProduct(_productId)
        returns (address[] memory)
    {
        return products[_productId].history;
    }

    function getStatus(uint _productId)
        public
        view
        validProduct(_productId)
        returns (Status)
    {
        return products[_productId].status;
    }
}