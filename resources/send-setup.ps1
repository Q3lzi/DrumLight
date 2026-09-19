param(
  [string]$Port,
  [string]$ConfigFile
)
$json = Get-Content -Path $ConfigFile -Raw
$sp = New-Object System.IO.Ports.SerialPort $Port, 115200, ([System.IO.Ports.Parity]::None), 8, ([System.IO.Ports.StopBits]::One)
$sp.ReadTimeout = 3000
$sp.NewLine = "`n"
try {
  $sp.Open()
  Start-Sleep -Milliseconds 500
  $sp.WriteLine("SETUP:" + $json)
  Start-Sleep -Milliseconds 1000
  $resp = ""
  try { $resp = $sp.ReadExisting() } catch {}
  Write-Output $resp
} catch {
  Write-Output ("FEHLER: " + $_.Exception.Message)
} finally {
  if ($sp.IsOpen) { $sp.Close() }
}
