param(
    [Parameter(Mandatory=$true)]
    [string]$vmnames,  # Comma-separated list: "vm1,vm2,vm3"
    
    [Parameter(Mandatory=$true)]
    [ValidateSet("start","stop")]
    [string]$action 
)

# Parse VM names
$targetVMs = ($vmnames -split ',') |
    ForEach-Object { $_.Trim() } |
    Where-Object { $_ } |
    Select-Object -Unique

Write-Output "Action: $action"
Write-Output "Target VMs: $($targetVMs -join ', ')"

# Authenticate with managed identity
try {
    Connect-AzAccount -Identity -ErrorAction Stop
} catch {
    Write-Error "Failed to authenticate with Managed Identity. $_"
    exit 1
}

# Grab all VMs with status once 
$allVMs = Get-AzVM -Status -ErrorAction Stop

# Helper to get normalized power state
function Get-PowerStateCode {
    param($vm)
    
    $statusCode = ($vm.Statuses | Where-Object { $_.Code -like 'PowerState/*' } | Select-Object -First 1).Code
    
    if ($statusCode) {
        return $statusCode
    }
    
    try {
        $freshVm = Get-AzVM -ResourceGroupName $vm.ResourceGroupName -Name $vm.Name -Status
        $statusCode = ($freshVm.Statuses | Where-Object { $_.Code -like 'PowerState/*' } | Select-Object -First 1).Code
        return $statusCode
    } catch {
        Write-Warning "Could not retrieve status for VM $($vm.Name)"
        return $null
    }
}

# Process each target VM
$processedCount = 0
$notFoundVMs = @()

foreach ($vmName in $targetVMs) {
    # Find the VM (case-insensitive)
    $vm = $allVMs | Where-Object { $_.Name -eq $vmName }
    
    if (-not $vm) {
        Write-Warning "VM not found: $vmName"
        $notFoundVMs += $vmName
        continue
    }
    
    $rg = $vm.ResourceGroupName
    $stateCode = Get-PowerStateCode $vm
    
    try {
        if ($action -eq "start") {
            if ($stateCode -notlike "*running*") {
                Write-Output "Starting $vmName in $rg (state: $stateCode)"
                Start-AzVM -Name $vmName -ResourceGroupName $rg -ErrorAction Stop -NoWait
                $processedCount++
            } else {
                Write-Output "Skip $vmName (already running)"
            }
        } else {
            if ($stateCode -like "*running*") {
                Write-Output "Stopping $vmName in $rg (state: $stateCode)"
                Stop-AzVM -Name $vmName -ResourceGroupName $rg -Force -ErrorAction Stop -NoWait
                $processedCount++
            } else {
                Write-Output "Skip $vmName (state: $stateCode)"
            }
        }
    } catch {
        Write-Error "Failed to $action VM $vmName in ${rg}: $($_.Exception.Message)"
    }
}

Write-Output "Completed '$action': processed $processedCount VMs"
if ($notFoundVMs.Count -gt 0) {
    Write-Warning "VMs not found: $($notFoundVMs -join ', ')"
}