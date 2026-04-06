# Poultry Supply Chain Smart Contract

## Project Title
**Poultry Supply Chain Tracking System**

## Selected Farm Business
Tracking the lifecycle of poultry products (chickens and eggs) from farmer to distributor.

## Description of System
This smart contract manages and tracks poultry products on the blockchain, ensuring:

- **Transparency** – Every transaction is visible on-chain  
- **Traceability** – Full ownership history of each product  
- **Data integrity** – Only authorized roles can register or transfer products  

The system allows farmers to register products, transfer ownership to distributors, and update product status from `Created` → `InTransit` → `Delivered`.

---

## Contract Features

1. **Product Registration**  
   - Farmers can register new products  
   - Stored data includes:  
     - Product ID  
     - Product Name/Type  
     - Quantity  
     - Origin (farm location)  
     - Date Created  
     - Current Owner  
     - Status  
     - Ownership History  

2. **Ownership Tracking**  
   - Tracks the current owner of each product  
   - Records each transfer between farmer and distributor  

3. **Status Updates**  
   - Status enum: `Created`, `InTransit`, `Delivered`  
   - Status updates automatically during transfers  

4. **Transfer Function**  
   - Ownership can be transferred  
   - Automatically updates product status  
   - Records transaction history  

5. **Access Control**  
   - Only authorized roles (farmer and distributor) can perform actions  
   - Farmer only: product registration  
   - Farmer & Distributor: transfer ownership  

6. **Data Retrieval**  
   - View product details  
   - View ownership history  
   - View current status  

---

## Sample Test Steps (Remix IDE)

**Step 1: Deploy Contract**  
- Deploy `PoultrySupplyChain.sol` using Remix VM or injected Web3  

**Step 2: Set Distributor**  
- Call `setDistributor(address)` with a valid Remix account address (distributor)  

**Step 3: Register Product**  
- Use `registerProduct("Eggs", 100, "Batangas")`  
- Product ID = 1  

**Step 4: Transfer Ownership (Farmer → Distributor)**  
- Call `transferOwnership(1)` from Farmer account  
- Status updates to `InTransit`  
- Current owner = Distributor address  

**Step 5: Transfer Ownership (Distributor → Delivered)**  
- Switch to Distributor account  
- Call `transferOwnership(1)`  
- Status updates to `Delivered`  

**Step 6: Verify Data**  
- `getProduct(1)` → Check all product details  
- `getStatus(1)` → Should return `Delivered`  
- `getHistory(1)` → Should show [Farmer address, Distributor address]  

---

## Screenshots
- Include screenshots of:  
  - Contract deployed  
  - Distributor set  
  - Product registered  
  - Ownership transferred (Farmer → Distributor)  
  - Ownership transferred (Delivered)  
  - Product details and history  

---

## Notes / Extra Info
- The system can be extended to include:  
  - QR code reference  
  - Price tracking  
  - Payment simulation  
- This ensures a fully traceable and tamper-proof poultry supply chain.