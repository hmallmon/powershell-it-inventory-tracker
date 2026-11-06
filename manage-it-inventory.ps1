<#
.SYNOPSIS
    IT Asset Inventory Management System.
.DESCRIPTION
    A local, JSON-backed menu-driven PowerShell script designed to manage hardware 
    inventory for an entry-level IT environment. Runs locally without infrastructure prerequisites.
#>

$JsonPath = Join-Path -Path $PSScriptRoot -ChildPath "inventory.json"
$LogPath  = Join-Path -Path $PSScriptRoot -ChildPath "inventory_log.txt"

# Helper Function: Logging
function Write-InventoryLog {
    param ([string]$Message)
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "[$Timestamp] $Message" | Out-File -FilePath $LogPath -Append
}

# Initialize Database JSON File if missing
if (-not (Test-Path -Path $JsonPath)) {
    @() | ConvertTo-Json | Out-File -FilePath $JsonPath -Encoding utf8
    Write-InventoryLog -Message "Initialized new inventory database file."
}

# Function: Load Inventory
function Get-Inventory {
    $Content = Get-Content -Path $JsonPath -Raw
    if ([string]::IsNullOrWhiteSpace($Content)) { return @() }
    return $Content | ConvertFrom-Json
}

# Function: Save Inventory
function Save-Inventory {
    param ($InventoryList)
    $InventoryList | ConvertTo-Json -Depth 5 | Out-File -FilePath $JsonPath -Encoding utf8
}

# Function: Add New Asset
function Add-Asset {
    Clear-Host
    Write-Host "=== Add New IT Asset ===" -ForegroundColor Cyan
    
    $Hostname = Read-Host "Enter Device Hostname (e.g., LAPTOP-CORP01)"
    if ([string]::IsNullOrWhiteSpace($Hostname)) {
        Write-Host "Error: Hostname cannot be empty." -ForegroundColor Red
        Pause; return
    }

    $Type = Read-Host "Enter Asset Type (Laptop/Desktop/Server/Monitor)"
    $User = Read-Host "Enter Assigned User Name"
    $Status = Read-Host "Enter Status (Deployed/In Storage/In Repair)"
    
    $Inventory = Get-Inventory
    $AssetTag = "AST-" + (Get-Date -Format "yyyy") + "-" + ("{0:D4}" -f ($Inventory.Count + 1))
    
    $NewAsset = [PSCustomObject]@{
        AssetTag     = $AssetTag
        Hostname     = $Hostname.ToUpper()
        Type         = $Type
        AssignedUser = $User
        Status       = $Status
        LastUpdated  = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
    }
    
    $Inventory += $NewAsset
    Save-Inventory -InventoryList $Inventory
    Write-InventoryLog -Message "Added new asset: $AssetTag ($Hostname)"
    
    Write-Host "`nSuccess: Asset $AssetTag created successfully!" -ForegroundColor Green
    Pause
}

# Function: View All Assets
function View-Inventory {
    Clear-Host
    Write-Host "=== Current IT Inventory ===" -ForegroundColor Cyan
    $Inventory = Get-Inventory
    
    if ($Inventory.Count -eq 0) {
        Write-Host "No assets found in the database." -ForegroundColor Yellow
    } else {
        $Inventory | Format-Table -AutoSize
    }
    Pause
}

# Function: Search Asset
function Search-Asset {
    Clear-Host
    Write-Host "=== Search Inventory ===" -ForegroundColor Cyan
    $SearchTerm = Read-Host "Enter Hostname, Asset Tag, or User to search"
    
    if ([string]::IsNullOrWhiteSpace($SearchTerm)) { return }
    
    $Inventory = Get-Inventory
    $Results = $Inventory | Where-Object {
        $_.Hostname -match $SearchTerm -or 
        $_.AssetTag -match $SearchTerm -or 
        $_.AssignedUser -match $SearchTerm
    }
    
    if ($Results) {
        Write-Host "`nMatch(es) Found:" -ForegroundColor Green
        $Results | Format-Table -AutoSize
    } else {
        Write-Host "`nNo matching assets found." -ForegroundColor Yellow
    }
    Pause
}

# Main Application Menu Interface Loop
do {
    Clear-Host
    Write-Host "=========================================" -ForegroundColor Blue
    Write-Host "      IT ASSET INVENTORY MANAGER         " -ForegroundColor White -BackgroundColor Blue
    Write-Host "=========================================" -ForegroundColor Blue
    Write-Host " [1] View Current Inventory"
    Write-Host " [2] Add New Hardware Asset"
    Write-Host " [3] Search Assets (Tag/Name/User)"
    Write-Host " [4] Exit System"
    Write-Host "=========================================" -ForegroundColor Blue
    $Choice = Read-Host "Select an option [1-4]"
    
    switch ($Choice) {
        "1" { View-Inventory }
        "2" { Add-Asset }
        "3" { Search-Asset }
        "4" { Write-Host "`nClosing inventory console management environment...`n" -ForegroundColor Yellow }
        Default { Write-Host "Invalid option. Press enter to try again..." -ForegroundColor Red; Pause }
    }
