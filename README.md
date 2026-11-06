# Local IT Asset Inventory Management Toolkit

A light-weight, interactive command-line interface (CLI) built natively in **PowerShell** to help internal desktop support teams catalog, track, and manage corporate endpoint device deployments.

## 🛠️ Key Features
* **Dynamic Menu Interface:** Simple numerical selection menu loop optimized for fast operations.
* **Auto Asset-Tag Generation:** Programmatically computes incremental serial asset tags (e.g., `AST-2026-0001`).
* **JSON-Backed Architecture:** Flat-file data parsing layer ensuring lightweight records management without SQL infrastructure dependencies.
* **Transaction Logging Engine:** Outputs structured logs to a separate flat file (`inventory_log.txt`) documenting administrative file manipulations.

## 📋 Technical Prerequisites
* **Operating System:** Microsoft Windows 10 / 11 
* **Execution Environment:** Windows PowerShell 5.1 or PowerShell Core 7+
* **Permissions:** Script executes in the local user context; administrative privileges are **not** strictly required.

## 🚀 Execution & Setup Guide

### 1. Download Content Locally
Clone the environment to your workstation using git:
```bash
git clone https://github.com
cd powershell-it-inventory-tracker
```

### 2. Configure Local Execution Policies
PowerShell restricts script executions by default. To unlock local runtime executions for your active workspace session, run an elevated prompt or bypass locally:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process
```

### 3. Run the Tool
```powershell
.\Manage-ITInventory.ps1
```

## 📁 Repository Blueprint
* `Manage-ITInventory.ps1`: Primary management framework engine housing functions, console wrappers, and transaction processing logic.
* `inventory.json`: System-managed flat database tracking your individual system records.
* `inventory_log.txt`: Append-only transactional history detailing environment events.
