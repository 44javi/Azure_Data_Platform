Write-Output "Stopping all VMs with tag 'shutdown_standard = true'..."

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
    $_.Tags["shutdown_standard"] -eq "true" -and $_.PowerState -eq "VM running"
}

if ($vms.Count -eq 0) {
    Write-Output "No running VMs found with shutdown_standard = true."
    exit 0
}

foreach ($vm in $vms) {
    try {
        Write-Output "Stopping VM: $($vm.Name) in RG: $($vm.ResourceGroupName)"
        Stop-AzVM -Name $vm.Name -ResourceGroupName $vm.ResourceGroupName -Force -ErrorAction Stop
    }
    catch {
        Write-Error "Failed to stop VM $($vm.Name). $_"
    }
}

Write-Output "Completed stopping tagged VMs."