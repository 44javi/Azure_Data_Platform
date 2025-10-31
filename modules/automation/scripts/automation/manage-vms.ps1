param(
    # Supplied by Azure Automation job parameters
    [string]$tagkey,
    [string]$tagvalue = "DEV|QA",
    [ValidateSet("start","stop")]
    [string]$action
)

# Parse and normalize env list (DEV|QA|PROD → @('DEV','QA','PROD'))
$envs = ($tagvalue -split '\|') |
  ForEach-Object { $_.Trim() } |
  Where-Object { $_ } |
  ForEach-Object { $_.ToUpper() } |
  Select-Object -Unique

Write-Output "Target environments: $($envs -join ', ')"
Write-Output "Action: $action"
Write-Output "Filtering by tag '$tagkey'..."

# Authenticate with managed identity
try {
    Connect-AzAccount -Identity -ErrorAction Stop
} catch {
    Write-Error "Failed to authenticate with Managed Identity. $_"
    exit 1
}

# Grab all VMs with status once 
$vms = Get-AzVM -Status -ErrorAction Stop

# Helper to get normalized power state
function Get-PowerStateCode {
    param($vm)
    $powerState = $vm.PowerState
    
    # If PowerState property exists directly
    if ($powerState) {
        return "PowerState/$powerState"
    }
    
    # Otherwise check Statuses collection
    $statusCode = ($vm.Statuses | Where-Object { $_.Code -like 'PowerState/*' } | Select-Object -First 1).Code
    
    # If still nothing, try to get it another way
    if (-not $statusCode) {
        # Get fresh status for this specific VM
        try {
            $freshVm = Get-AzVM -ResourceGroupName $vm.ResourceGroupName -Name $vm.Name -Status
            $statusCode = ($freshVm.Statuses | Where-Object { $_.Code -like 'PowerState/*' } | Select-Object -First 1).Code
        } catch {
            Write-Warning "Could not retrieve status for VM $($vm.Name)"
        }
    }
    
    return $statusCode
}

# Process each environment separately
foreach ($env in $envs) {
    # Case-insensitive tag compare; some tags can be missing
    $targets = $vms | Where-Object {
        $_.Tags.ContainsKey($tagkey) -and
        ($_.Tags[$tagkey]).ToString().Trim().ToUpper() -eq $env
    }

    Write-Output "[$env] Candidates: $($targets.Count)"

    foreach ($vm in $targets) {
        $rg = $vm.ResourceGroupName
        $name = $vm.Name
        $stateCode = Get-PowerStateCode $vm  # e.g., PowerState/running, PowerState/stopped, PowerState/deallocated

        try {
            if ($action -eq "start") {
                # Start if not running (covers stopped & deallocated)
                if ($stateCode -ne "PowerState/running") {
                    Write-Output "[$env] Starting $name in $rg (state: $stateCode)"
                    Start-AzVM -Name $name -ResourceGroupName $rg -ErrorAction Stop -NoWait
                } else {
                    Write-Output "[$env] Skip $name (already running)"
                }
            } else {
                # Stop only if running
                if ($stateCode -eq "PowerState/running") {
                    Write-Output "[$env] Stopping $name in $rg (state: running)"
                    Stop-AzVM -Name $name -ResourceGroupName $rg -Force -ErrorAction Stop -NoWait
                } else {
                    Write-Output "[$env] Skip $name (state: $stateCode)"
                }
            }
        } catch {
            Write-Error "[$env] Failed to $action VM $name in ${rg}: $($_.Exception.Message)"
        }
    }
}

Write-Output "Completed '$action' for tag '$tagkey' across envs: $($envs -join ', ')."
