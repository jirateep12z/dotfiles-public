function CheckInstallCompatibility {
  if ($psversiontable.os -notlike "*windows*") {
    write-host "This install script does not support the current os."
    return
  }
}

function Menu {
  get-content "$psscriptroot/ascii.txt" -encoding utf8
  write-host "1. Install powershell modules."
  write-host "2. Install scoop packages."
  write-host "3. Install node.js lts version."
  write-host "4. Install npm packages."
  write-host "5. Install visual studio code extensions."
  write-host "6. Install all packages."
  write-host "7. Uninstall powershell modules."
  write-host "8. Uninstall scoop packages."
  write-host "9. Uninstall node.js lts version."
  write-host "10. Uninstall npm packages."
  write-host "11. Uninstall visual studio code extensions."
  write-host "12. Uninstall all packages."
  write-host "13. Configure powershell."
  write-host "14. Configure windows terminal."
  write-host "15. Configure vim."
  write-host "16. Configure neovim."
  write-host "17. Configure script."
  write-host "18. Configure git."
  write-host "19. Configure lazygit."
  write-host "20. Configure python."
  write-host "21. Configure commitizen."
  write-host "22. Configure visual studio code."
  write-host "23. Configure all applications."
  write-host "24. Remove powershell configuration."
  write-host "25. Remove windows terminal configuration."
  write-host "26. Remove vim configuration."
  write-host "27. Remove neovim configuration."
  write-host "28. Remove script configuration."
  write-host "29. Remove git configuration."
  write-host "30. Remove lazygit configuration."
  write-host "31. Remove python configuration."
  write-host "32. Remove commitizen configuration."
  write-host "33. Remove visual studio code configuration."
  write-host "34. Remove all applications."
  write-host "q. Quit."
  write-host ""
}

function InstallPackage {
  param (
    [string]$package_name,
    [string]$package_list_path,
    [string]$install_command,
    [string]$additional_params
  )
  try {
    if ($package_name) {
      write-host "Installing $package_name."
    }
    get-content $package_list_path | foreach-object {
      if ($additional_params) {
        invoke-expression "$install_command $_ $additional_params"
      } else {
        invoke-expression "$install_command $_"
      }
    }
  } catch {
    write-error "An error occurred while installing $package_name $_"
  }
}

function UninstallPackage {
  param (
    [string]$package_name,
    [string]$package_list_path,
    [string]$uninstall_command
  )
  try {
    if ($package_name) {
      write-host "Uninstalling $package_name."
    }
    get-content $package_list_path | foreach-object {
      invoke-expression "$uninstall_command $_"
    }
  } catch {
    write-error "An error occurred while uninstalling $package_name $_"
  }
}

function InstallPowerShellModules {
  try {
    winget install --id microsoft.powershell -s winget
    InstallPackage -package_name "powershell modules" -package_list_path "$psscriptroot/.requirement/powershell.txt" -install_command "install-module -name" -additional_params "-scope currentuser -allowclobber -force"
  } catch {
    write-error "An error occurred while installing powershell modules $_"
  }
}

function UninstallPowerShellModules {
  try {
    UninstallPackage -package_name "powershell modules" -package_list_path "$psscriptroot/.requirement/powershell.txt" -uninstall_command "uninstall-module -name"
  } catch {
    write-error "An error occurred while uninstalling powershell modules $_"
  }
}

function InstallScoopPackages {
  try {
    if (-not (get-command scoop -erroraction silentlycontinue)) {
      write-warning "Scoop is not installed. Installing..."
      set-executionpolicy -executionpolicy remotesigned -scope currentuser
      invoke-restmethod -uri https://get.scoop.sh | invoke-expression
    }
    InstallPackage -package_name "scoop buckets" -package_list_path "$psscriptroot/.requirement/scoop_bucket.txt" -install_command "scoop bucket add"
    InstallPackage -package_name "scoop packages" -package_list_path "$psscriptroot/.requirement/scoop_package.txt" -install_command "scoop install"
    InstallPackage -package_name "scoop applications" -package_list_path "$psscriptroot/.requirement/scoop_application.txt" -install_command "scoop install"
    InstallPackage -package_name "scoop fonts" -package_list_path "$psscriptroot/.requirement/scoop_font.txt" -install_command "scoop install"
  } catch {
    write-error "An error occurred while installing scoop packages $_"
  }
}

function UninstallScoopPackages {
  try {
    UninstallPackage -package_name "scoop packages" -package_list_path "$psscriptroot/.requirement/scoop_package.txt" -uninstall_command "scoop uninstall"
    UninstallPackage -package_name "scoop applications" -package_list_path "$psscriptroot/.requirement/scoop_application.txt" -uninstall_command "scoop uninstall"
    UninstallPackage -package_name "scoop fonts" -package_list_path "$psscriptroot/.requirement/scoop_font.txt" -uninstall_command "scoop uninstall"
  } catch {
    write-error "An error occurred while uninstalling scoop packages $_"
  }
}

function InstallNodeJS {
  try {
    if (-not (get-command nvm -erroraction silentlycontinue)) {
      write-warning "Scoop is not installed. Installing..."
      InstallScoopPackages
    }
    write-host "Installing node.js lts version."
    nvm install lts
    write-host "Using node.js lts version."
    nvm use lts
  } catch {
    write-error "An error occurred while installing node.js lts version $_"
  }
}

function UninstallNodeJS {
  try {
    if (-not (get-command nvm -erroraction silentlycontinue)) {
      write-warning "Scoop is not installed. Installing..."
      InstallScoopPackages
    }
    write-host "Uninstalling node.js lts version."
    nvm uninstall lts
  } catch {
    write-error "An error occurred while uninstalling node.js lts version $_"
  }
}

function InstallNPMPackages {
  try {
    if (-not (get-command npm -erroraction silentlycontinue)) {
      write-warning "Node.js is not installed. Installing..."
      InstallNodeJS
    }
    InstallPackage -package_name "npm packages" -package_list_path "$psscriptroot/.requirement/npm.txt" -install_command "npm install -g"
  } catch {
    write-error "An error occurred while installing npm packages $_"
  }
}

function UninstallNPMPackages {
  try {
    if (-not (get-command npm -erroraction silentlycontinue)) {
      write-warning "Node.js is not installed. Installing..."
      InstallNodeJS
    }
    UninstallPackage -package_name "npm packages" -package_list_path "$psscriptroot/.requirement/npm.txt" -uninstall_command "npm uninstall -g"
  } catch {
    write-error "An error occurred while uninstalling npm packages $_"
  }
}

function InstallVisualStudioCodeExtensions {
  try {
    if (-not (get-command code -erroraction silentlycontinue)) {
      write-warning "Scoop is not installed. Installing..."
      InstallScoopPackages
    }
    InstallPackage -package_name "visual studio code extensions" -package_list_path "$psscriptroot/.requirement/visual_studio_code.txt" -install_command "code --install-extension" -additional_params "--force"
  } catch {
    write-error "An error occurred while installing visual studio code extensions $_"
  }
}

function UninstallVisualStudioCodeExtensions {
  try {
    if (-not (get-command code -erroraction silentlycontinue)) {
      write-warning "Scoop is not installed. Installing..."
      InstallScoopPackages
    }
    UninstallPackage -package_name "visual studio code extensions" -package_list_path "$psscriptroot/.requirement/visual_studio_code.txt" -uninstall_command "code --uninstall-extension"
  } catch {
    write-error "An error occurred while uninstalling visual studio code extensions $_"
  }
}

function InstallAllPackages {
  write-host "Installing all packages."
  InstallPowerShellModules
  InstallScoopPackages
  InstallNodeJS
  InstallNPMPackages
  InstallVisualStudioCodeExtensions
}

function UninstallAllPackages {
  write-host "Uninstalling all packages."
  UninstallPowerShellModules
  UninstallScoopPackages
  UninstallNodeJS
  UninstallNPMPackages
  UninstallVisualStudioCodeExtensions
}

function SetApplicationConfig {
  param (
  [string]$app_name,
  [string]$source_path,
  [string]$destination_path,
  [string[]]$extensions = @(),
  [string[]]$files = @()
  )
  try {
    if ($app_name) {
      write-host "Configuring $app_name."
    }
    if (test-path $destination_path) {
      if ($extensions.count -eq 0 -and $files.count -eq 0) {
        remove-item -path "$destination_path" -recurse -force
        new-item -path "$destination_path" -itemtype directory -force
      } else {
        if ($extensions.count -gt 0) {
          foreach ($extension in $extensions) {
            get-childitem -path "$destination_path" -filter "*.$extension" -recurse | remove-item -recurse -force
          }
        }
        if ($files.count -gt 0) {
          foreach ($file in $files) {
            get-childitem -path "$destination_path" -filter "$file" -recurse | remove-item -recurse -force
          }
        }
      }
    } else {
      new-item -path "$destination_path" -itemtype directory -force
    }
    if ((get-item $source_path).psiscontainer) {
      copy-item -path "$source_path/*" -destination "$destination_path" -recurse -force
    } else {
      copy-item -path "$source_path" -destination "$destination_path" -recurse -force
    }
  } catch {
    write-error "An error occurred while configuring $app_name $_"
  }
}

function RemoveApplication {
  param (
  [string]$app_name,
  [string]$destination_path,
  [string[]]$extensions = @(),
  [string[]]$files = @()
  )
  try {
    if ($app_name) {
      write-host "Removing $app_name."
    }
    if (test-path $destination_path) {
      if ($extensions.count -eq 0 -and $files.count -eq 0) {
        remove-item -path "$destination_path" -recurse -force
      } else {
        if ($extensions.count -gt 0) {
          foreach ($extension in $extensions) {
            get-childitem -path "$destination_path" -filter "*.$extension" -recurse | remove-item -recurse -force
          }
        }
        if ($files.count -gt 0) {
          foreach ($file in $files) {
            get-childitem -path "$destination_path" -filter "$file" -recurse | remove-item -recurse -force
          }
        }
      }
    }
  } catch {
    write-error "An error occurred while removing $app_name $_"
  }
}

function SetPowerShellConfig {
  $paths = get-module -listavailable -all | select-object -expandproperty path
  foreach ($path in $paths) {
    if ($path -like "*Documents\*") {
      $powershell_path = "$ENV:USERPROFILE\Documents"
    } elseif ($path -like "*OneDrive\Documents\*") {
      $powershell_path = "$ENV:USERPROFILE\OneDrive\Documents"
    }
  }
  SetApplicationConfig -app_name "windows powershell" -source_path "$psscriptroot/.config/powershell" -destination_path "$powershell_path/WindowsPowerShell" -extensions @("txt", "json", "ps1")
  Rename-Item -path "$powershell_path/WindowsPowerShell/microsoft.powershell_profile.ps1" -newname "Microsoft.PowerShell_profile.ps1" -force
  Copy-Item -path "$powershell_path/WindowsPowerShell/Modules/*" -erroraction silentlycontinue -Destination "$powershell_path/PowerShell/Modules" -Recurse -force
  SetApplicationConfig -app_name "powershell" -source_path "$psscriptroot/.config/powershell" -destination_path "$powershell_path/PowerShell" -extensions @("txt", "json", "ps1")
  Rename-Item -path "$powershell_path/PowerShell/microsoft.powershell_profile.ps1" -newname "Microsoft.PowerShell_profile.ps1" -force
  Copy-Item -path "$powershell_path/PowerShell/Modules/*" -erroraction silentlycontinue -Destination "$powershell_path/WindowsPowerShell/Modules" -Recurse -force
}

function RemovePowerShellConfig {
  $paths = get-module -listavailable -all | select-object -expandproperty path
  foreach ($path in $paths) {
    if ($path -like "*Documents\*") {
      $powershell_path = "$ENV:USERPROFILE\Documents"
    } elseif ($path -like "*OneDrive\Documents\*") {
      $powershell_path = "$ENV:USERPROFILE\OneDrive\Documents"
    }
  }
  RemoveApplicationConfig -app_name "windows powershell" -destination_path "$powershell_path/WindowsPowerShell"
  RemoveApplicationConfig -app_name "powershell" -destination_path "$powershell_path/PowerShell"
}

function SetWindowsTerminalConfig {
  SetApplicationConfig -app_name "windows terminal" -source_path "$psscriptroot/.config/windows terminal" -destination_path "$ENV:USERPROFILE/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState" -files @("settings.json")
}

function RemoveWindowsTerminalConfig {
  RemoveApplicationConfig -app_name "windows terminal" -destination_path "$ENV:USERPROFILE/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState" -files @("settings.json")
}

function SetVimConfig {
  SetApplicationConfig -app_name "vim" -source_path "$psscriptroot/.config/vim" -destination_path "$ENV:USERPROFILE" -files @(".vimrc")
}

function RemoveVimConfig {
  RemoveApplicationConfig -app_name "vim" -destination_path "$ENV:USERPROFILE" -files @(".vimrc")
}

function SetNeovimConfig {
  SetApplicationConfig -app_name "neovim" -source_path "$psscriptroot/.config/nvim" -destination_path "$ENV:USERPROFILE/AppData/Local/nvim"
}

function RemoveNeovimConfig {
  RemoveApplicationConfig -app_name "neovim" -destination_path "$ENV:USERPROFILE/AppData/Local/nvim"
}

function SetScriptConfig {
  SetApplicationConfig -app_name "script" -source_path "$psscriptroot/.script" -destination_path "$ENV:USERPROFILE/AppData/Local/script"
}

function RemoveScriptConfig {
  RemoveApplicationConfig -app_name "script" -destination_path "$ENV:USERPROFILE/AppData/Local/script"
}

function SetGitConfig {
  SetApplicationConfig -app_name "git" -source_path "$psscriptroot/.gitconfig" -destination_path "$ENV:USERPROFILE" -files @(".gitconfig")
}

function RemoveGitConfig {
  RemoveApplicationConfig -app_name "git" -destination_path "$ENV:USERPROFILE" -files @(".gitconfig")
}

function SetLazyGitConfig {
  SetApplicationConfig -app_name "lazygit" -source_path "$psscriptroot/.config/lazygit" -destination_path "$ENV:USERPROFILE/AppData/Local/lazygit"
}

function RemoveLazyGitConfig {
  RemoveApplicationConfig -app_name "lazygit" -destination_path "$ENV:USERPROFILE/AppData/Local/lazygit"
}

function SetPythonConfig {
  SetApplicationConfig -app_name "python" -source_path "$psscriptroot/.config/pip" -destination_path "$ENV:USERPROFILE/AppData/Local/pip"
}

function RemovePythonConfig {
  RemoveApplicationConfig -app_name "python" -destination_path "$ENV:USERPROFILE/AppData/Local/pip"
}

function SetCommitizenConfig {
  SetApplicationConfig -app_name "commitizen" -source_path "$psscriptroot/.config/commitizen" -destination_path "$ENV:USERPROFILE" -files @(".czrc")
}

function RemoveCommitizenConfig {
  RemoveApplicationConfig -app_name "commitizen" -destination_path "$ENV:USERPROFILE" -files @(".czrc")
}

function SetVisualStudioCodeConfig {
  if (-not (get-command code -erroraction silentlycontinue)) {
    write-warning "Scoop is not installed. Installing..."
    InstallScoopPackages
  }
  $paths = get-command code -erroraction silentlycontinue | select-object -expandproperty path
  foreach ($path in $paths) {
    if ($path -like "*Microsoft VS Code\*") {
      $vscode_path = "$ENV:USERPROFILE/AppData/Roaming/Code/User"
    } elseif ($path -like "*scoop\apps\vscode\current\*") {
      $vscode_path = "$ENV:USERPROFILE/scoop/apps/vscode/current/data/user-data/User"
    }
  }
  SetApplicationConfig -app_name "visual studio code" -source_path "$psscriptroot/.config/visual studio code" -destination_path "$vscode_path" -extensions @("json")
}

function RemoveVisualStudioCodeConfig {
  if (-not (get-command code -erroraction silentlycontinue)) {
    write-warning "Scoop is not installed. Installing..."
    InstallScoopPackages
  }
  $paths = get-command code -erroraction silentlycontinue | select-object -expandproperty path
  foreach ($path in $paths) {
    if ($path -like "*Microsoft VS Code\*") {
      $vscode_path = "$ENV:USERPROFILE/AppData/Roaming/Code/User"
    } elseif ($path -like "*scoop\apps\vscode\current\*") {
      $vscode_path = "$ENV:USERPROFILE/scoop/apps/vscode/current/data/user-data/User"
    }
  }
  RemoveApplicationConfig -app_name "visual studio code" -destination_path "$vscode_path" -extensions @("json")
}

function SetAllAppicationConfigs {
  write-host "Configuring all applications."
  SetPowerShellConfig
  SetWindowsTerminalConfig
  SetVimConfig
  SetNeovimConfig
  SetScriptConfig
  SetGitConfig
  SetLazyGitConfig
  SetPythonConfig
  SetCommitizenConfig
  SetVisualStudioCodeConfig
}

function RemoveAllAppicationConfigs {
  write-host "Removing all application configurations."
  RemovePowerShellConfig
  RemoveWindowsTerminalConfig
  RemoveVimConfig
  RemoveNeovimConfig
  RemoveScriptConfig
  RemoveGitConfig
  RemoveLazyGitConfig
  RemovePythonConfig
  RemoveCommitizenConfig
  RemoveVisualStudioCodeConfig
}

function Main {
  do {
    CheckInstallCompatibility
    Menu
    $choice = read-host "Enter your choice"
    switch ($choice) {
      "1" { InstallPowerShellModules }
      "2" { InstallScoopPackages }
      "3" { InstallNodeJS }
      "4" { InstallNPMPackages }
      "5" { InstallVisualStudioCodeExtensions }
      "6" { InstallAllPackages }
      "7" { UninstallPowerShellModules }
      "8" { UninstallScoopPackages }
      "9" { UninstallNodeJS }
      "10" { UninstallNPMPackages }
      "11" { UninstallVisualStudioCodeExtensions }
      "12" { UninstallAllPackages }
      "13" { SetPowerShellConfig }
      "14" { SetWindowsTerminalConfig }
      "15" { SetVimConfig }
      "16" { SetNeovimConfig }
      "17" { SetScriptConfig }
      "18" { SetGitConfig }
      "19" { SetLazyGitConfig }
      "20" { SetPythonConfig }
      "21" { SetCommitizenConfig }
      "22" { SetVisualStudioCodeConfig }
      "23" { SetAllAppicationConfigs }
      "24" { RemovePowerShellConfig }
      "25" { RemoveWindowsTerminalConfig }
      "26" { RemoveVimConfig }
      "27" { RemoveNeovimConfig }
      "28" { RemoveScriptConfig }
      "29" { RemoveGitConfig }
      "30" { RemoveLazyGitConfig }
      "31" { RemovePythonConfig }
      "32" { RemoveCommitizenConfig }
      "33" { RemoveVisualStudioCodeConfig }
      "34" { RemoveAllAppicationConfigs }
      "q" { break }
      default { write-warning "Invalid choice. Please try again." }
    }
  } while ($choice -ne "q")
}

Main
