Write-Output "Starting all VMs with tag 'shutdown_standard = true'..."

# Login using Managed Identity
try {
    Connect-AzAccount -Identity -ErrorAction Stop
}
catch {
    Write-Error "Failed to authenticate with Managed Identity. $_"
    exit 1
}

# Get all VMs with shutdown_standard=true
$vms = Get-AzVM -Status | Where-Object {
    $_.Tags["shutdown_standard"] -eq "true" -and $_.PowerState -eq "VM deallocated"
}

if ($vms.Count -eq 0) {
    Write-Output "No stopped VMs found with shutdown_standard = true."
    exit 0
}

foreach ($vm in $vms) {
    try {
        Write-Output "Starting VM: $($vm.Name) in RG: $($vm.ResourceGroupName)"
        Start-AzVM -Name $vm.Name -ResourceGroupName $vm.ResourceGroupName -ErrorAction Stop
    }
    catch {
        Write-Error "Failed to start VM $($vm.Name). $_"
    }
}

Write-Output "Completed starting tagged VMs."