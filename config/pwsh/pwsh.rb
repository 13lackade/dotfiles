namespace :pwsh do
  config_dir = "#{HOME}/Documents/PowerShell"

  files({
    "#{config_dir}/Microsoft.PowerShell_profile.ps1" => 'config/pwsh/Microsoft.PowerShell_profile.ps1',
  })
end if WINDOWS
