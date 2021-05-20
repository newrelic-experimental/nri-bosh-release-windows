
Write-Host "Installing New Relic Infrastructure"

$DataStamp = get-date -Format yyyyMMddTHHmmss
$logFile = 'C:\var\vcap\sys\log\install-nri\install-nri.log'

Write-Host $DataStamp "`r`n"

$arrService = Get-Service -Name "newrelic-infra" -ErrorAction SilentlyContinue
if ($arrService) {
  Write-Host "New Relic Inrastructure already installed."
  if ($arrService.Status -eq 'Running') {
    Write-Host "Stopping New Relic Infrastructure"
    Stop-Service "newrelic-infra"
    Start-Sleep -seconds 30
    $arrService.Refresh()
    if ($arrService.Status -eq 'Running') {
      Write-Host "New Relic Infrastructure did not stop"
    }
  }
}

$MSIArguments = @(
    "/qn"
    "/i"
    "C:\var\vcap\packages\nr-infra\newrelic-infra.1.17.1.msi"
    "/L*v"
    $logFile
)

Start-Process "msiexec.exe" -ArgumentList $MSIArguments -Wait -NoNewWindow

Write-Host "Installer done. `r`n"

New-Item -Path "c:\var\vcap" -Name "install-nri" -ItemType "directory" -ErrorAction SilentlyContinue
Write-Host "Created c:\var\vcap\install-nri log directory. `r`n"
New-Item -Path "c:\var\vcap\install-nri" -Name "newrelic-infa.log" -ItemType "file" -ErrorAction SilentlyContinue
Write-Host "Created c:\var\vcap\install-nri\newrelic-infa.log file. `r`n"

$configFile = "C:\Program Files\New Relic\newrelic-infra\newrelic-infra.yml"

Set-Content -Path $configFile -Value "license_key: <%= p('infra_agent.license_key') %>`r`n"

Add-Content -Path $configFile -Value "display_name: <%= spec.name + '-' + spec.id %>`r`n"
Add-Content -Path $configFile -Value "log_file: c:\var\vcap\install-nri\newrelic-infa.log`r`n"

<%- if_p('infra_agent.agent_props') do |props| -%>
  <%- props.each do |key, value| -%>
Add-Content -Path $configFile -Value "<%= key %>: <%= value %>"
  <%- end -%>
Add-Content -Path $configFile -Value "`r`n"
<%- end -%>

Add-Content -Path $configFile -Value "custom_attributes:"
Add-Content -Path $configFile -Value "  bosh.az: <%= spec.az %>"
Add-Content -Path $configFile -Value "  bosh.bootstrap: <%= spec.bootstrap %>"
Add-Content -Path $configFile -Value "  bosh.deployment: <%= spec.deployment %>"
Add-Content -Path $configFile -Value "  bosh.id: <%= spec.id %>"
Add-Content -Path $configFile -Value "  bosh.index: <%= spec.index %>"
Add-Content -Path $configFile -Value "  bosh.ip: <%= spec.ip %>"
Add-Content -Path $configFile -Value "  bosh.name: <%= spec.name %>"
Add-Content -Path $configFile -Value "  bosh.environment: <%= p('infra_agent.environment') %>"

<%- if_p('infra_agent.custom_attributes') do |cas| -%>
  <%- cas.each do |key, value| -%>
     <%- unless value.empty? -%>
Add-Content -Path $configFile -Value "  bosh.<%= key %>: <%= value %>"
     <%- end -%>
  <%- end -%>
<%- end -%>

Start-Service "newrelic-infra"
