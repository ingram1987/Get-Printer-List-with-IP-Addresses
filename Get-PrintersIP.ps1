#######################################
####Created by Ryan Ingram Watson######
######On 2024-5-29#####################
#######################################

# CSV Export Path
$csvFilePath = "C:\Printers.csv"

# Check if Printer IP responds to ping
function Test-Pingable {
    param (
        [string]$IPAddress
    )

    try {
        $ping = Test-Connection -ComputerName $IPAddress -Count 1 -ErrorAction Stop
        return $true
    }
    catch {
        return $false
    }
}

$printers = Get-Printer
$printerDetails = @()

# Loop through each printer and get its IP address
foreach ($printer in $printers) {
    $printerName = $printer.Name
    $portName = $printer.PortName
    $portConfig = Get-PrinterPort -Name $portName
    $ipAddress = $portConfig.PrinterHostAddress
    $pingable = if ($ipAddress) { Test-Pingable -IPAddress $ipAddress } else { $false }

    $printerDetails += [PSCustomObject]@{
        PrinterName = $printerName
        IPAddress   = $ipAddress
        Pingable    = if ($pingable) { "True" } else { "False" }
    }
}

# Output
$printerDetails | Format-Table -AutoSize -Wrap
$printerDetails | Export-Csv -Path $csvFilePath -NoTypeInformation
