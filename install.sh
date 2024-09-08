#!/bin/bash

directory=$(dirname "$0")

CheckInstallCompatibility() {
  if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "This install script does not support the current os."
    exit 1
  fi
}

Menu() {
  cat "$directory/ascii.txt"
  echo "1. Install homebrew packages."
  echo "2. Install visual studio code extensions."
  echo "3. Install all packages."
  echo "4. Uninstall homebrew packages."
  echo "5. Uninstall visual studio code extensions."
  echo "6. Uninstall all packages."
  echo "7. Set fish as default shell."
  echo "8. Configure fish."
  echo "9. Configure tmux."
  echo "10. Configure vim."
  echo "11. Configure neovim."
  echo "12. Configure scripts."
  echo "13. Configure git."
  echo "14. Configure lazygit."
  echo "15. Configure commitizen."
  echo "16. Configure pip."
  echo "17. Configure visual studio code."
  echo "18. Configure all applications."
  echo "19. Remove fish configuration."
  echo "20. Remove tmux configuration."
  echo "21. Remove vim configuration."
  echo "22. Remove neovim configuration."
  echo "23. Remove scripts configuration."
  echo "24. Remove git configuration."
  echo "25. Remove lazygit configuration."
  echo "26. Remove commitizen configuration."
  echo "27. Remove pip configuration."
  echo "28. Remove visual studio code configuration."
  echo "29. Remove all application configurations."
  echo "q. Quit."
  echo ""
}

InstallPackages() {
  local package_name=""
  local package_list_path=""
  local install_command=""
  local additional_params=""
  while [[ "$#" -gt 0 ]]; do
    case $1 in
    -package_name)
      package_name="$2"
      shift
      ;;
    -package_list_path)
      package_list_path="$2"
      shift
      ;;
    -install_command)
      install_command="$2"
      shift
      ;;
    -additional_params)
      additional_params="$2"
      shift
      ;;
    *)
      echo "Unknown parameter passed: $1"
      exit 1
      ;;
    esac
    shift
  done
  if [[ -n "$package_name" ]]; then
    echo "Installing $package_name."
  fi
  while IFS= read -r package; do
    if [ -n "$additional_params" ]; then
      eval "$install_command $package $additional_params"
    else
      eval "$install_command $package"
    fi
  done <"$package_list_path"
}

UninstallPackages() {
  local package_name=""
  local package_list_path=""
  local uninstall_command=""
  while [[ "$#" -gt 0 ]]; do
    case $1 in
    -package_name)
      package_name="$2"
      shift
      ;;
    -package_list_path)
      package_list_path="$2"
      shift
      ;;
    -uninstall_command)
      uninstall_command="$2"
      shift
      ;;
    *)
      echo "Unknown parameter passed: $1"
      exit 1
      ;;
    esac
    shift
  done
  if [[ -n "$package_name" ]]; then
    echo "Uninstalling $package_name."
  fi
  while IFS= read -r package; do
    eval "$uninstall_command $package"
  done <"$package_list_path"
}

InstallHomebrewPackages() {
  if [[ ! -x "$(command -v brew)" ]]; then
    echo "Homebrew is not installed. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  InstallPackages -package_name "homebrew packages" -package_list_path "$directory/.requirement/brew_package.txt" -install_command "brew install"
  InstallPackages -package_name "homebrew applications" -package_list_path "$directory/.requirement/brew_application.txt" -install_command "brew install --cask"
  InstallPackages -package_name "homebrew fonts" -package_list_path "$directory/.requirement/brew_font.txt" -install_command "brew install"
}

UninstallHomebrewPackages() {
  UninstallPackages -package_name "homebrew packages" -package_list_path "$directory/.requirement/brew_package.txt" -uninstall_command "brew uninstall"
  UninstallPackages -package_name "homebrew applications" -package_list_path "$directory/.requirement/brew_application.txt" -uninstall_command "brew uninstall --cask"
  UninstallPackages -package_name "homebrew fonts" -package_list_path "$directory/.requirement/brew_font.txt" -uninstall_command "brew uninstall"
}

InstallVisualStudioCodeExtensions() {
  if [[ ! -x "$(command -v code)" ]]; then
    echo "Homebrew is not installed. Installing..."
    InstallHomebrewPackages
  fi
  InstallPackages -package_name "visual studio code extensions" -package_list_path "$directory/.requirement/visual_studio_code.txt" -install_command "code --install-extension"
}

UninstallVisualStudioCodeExtensions() {
  UninstallPackages -package_name "visual studio code extensions" -package_list_path "$directory/.requirement/visual_studio_code.txt" -uninstall_command "code --uninstall-extension"
}

InstallAllPackages() {
  echo "Installing all packages."
  InstallHomebrewPackages
  InstallVisualStudioCodeExtensions
}

UninstallAllPackages() {
  echo "Uninstalling all packages."
  UninstallHomebrewPackages
  UninstallVisualStudioCodeExtensions
}

function SetFishToDefaultShell() {
  echo "Setting fish to default shell."
  if ! grep -q "$(which fish)" /etc/shells; then
    echo "Adding fish to /etc/shells."
    sudo sh -c 'echo "$(which fish)" >> /etc/shells'
  else
    echo "Fish is already in /etc/shells."
  fi
  echo "Changing default shell to fish."
  chsh -s "$(which fish)"
  echo "Adding fish to path."
  fish -c 'fish_add_path (dirname (which brew))'
}

SetApplicationConfig() {
  local app_name="$1"
  local source_path="$2"
  local destination_path="$3"
  local extensions=()
  local files=()
  while [[ $# -gt 0 ]]; do
    case $1 in
    -app_name)
      app_name="$2"
      shift 2
      ;;
    -source_path)
      source_path="$2"
      shift 2
      ;;
    -destination_path)
      destination_path="$2"
      shift 2
      ;;
    -extensions)
      shift
      while [[ $# -gt 0 && ! $1 == -* ]]; do
        extensions+=("$1")
        shift
      done
      ;;
    -files)
      shift
      while [[ $# -gt 0 && ! $1 == -* ]]; do
        files+=("$1")
        shift
      done
      ;;
    *)
      echo "Unknown parameter passed: $1"
      return 1
      ;;
    esac
  done
  if [[ -n "$app_name" ]]; then
    echo "Configuring $app_name."
  fi
  if [[ -d "$destination_path" ]]; then
    if [[ ${#extensions[@]} -eq 0 && ${#files[@]} -eq 0 ]]; then
      rm -rf "$destination_path"
      mkdir -p "$destination_path"
    else
      if [[ ${#extensions[@]} -gt 0 ]]; then
        for extension in "${extensions[@]}"; do
          rm -rf "$destination_path"/*."$extension"
        done
      fi
      if [[ ${#files[@]} -gt 0 ]]; then
        for file in "${files[@]}"; do
          rm -rf "$destination_path"/"$file"
        done
      fi
    fi
  else
    mkdir -p "$destination_path"
  fi
  if [[ -d "$source_path" ]]; then
    cp -r "$source_path"/. "$destination_path"
  else
    cp -r "$source_path" "$destination_path"
  fi
}

RemoveApplicationConfig() {
  local app_name="$1"
  local destination_path="$2"
  local extensions=()
  local files=()
  while [[ $# -gt 0 ]]; do
    case $1 in
    -app_name)
      app_name="$2"
      shift 2
      ;;
    -destination_path)
      destination_path="$2"
      shift 2
      ;;
    -extensions)
      shift
      while [[ $# -gt 0 && ! $1 == -* ]]; do
        extensions+=("$1")
        shift
      done
      ;;
    -files)
      shift
      while [[ $# -gt 0 && ! $1 == -* ]]; do
        files+=("$1")
        shift
      done
      ;;
    *)
      echo "Unknown parameter passed: $1"
      return 1
      ;;
    esac
  done
  if [[ -n "$app_name" ]]; then
    echo "Removing $app_name."
  fi
  if [[ -d "$destination_path" ]]; then
    if [[ ${#extensions[@]} -eq 0 && ${#files[@]} -eq 0 ]]; then
      rm -rf "$destination_path"
      mkdir -p "$destination_path"
    else
      if [[ ${#extensions[@]} -gt 0 ]]; then
        for extension in "${extensions[@]}"; do
          rm -rf "$destination_path"/*."$extension"
        done
      fi
      if [[ ${#files[@]} -gt 0 ]]; then
        for file in "${files[@]}"; do
          rm -rf "$destination_path"/"$file"
        done
      fi
    fi
  fi
}

SetFishConfig() {
  SetApplicationConfig -app_name "fish" -source_path "$directory/.config/fish" -destination_path "$HOME/.config/fish"
}

RemoveFishConfig() {
  RemoveApplicationConfig -app_name "fish" -destination_path "$HOME/.config/fish"
}

SetTmuxConfig() {
  SetApplicationConfig -app_name "tmux" -source_path "$directory/.config/tmux" -destination_path "$HOME/.config/tmux"
}

RemoveTmuxConfig() {
  RemoveApplicationConfig -app_name "tmux" -destination_path "$HOME/.config/tmux"
}

SetVimConfig() {
  SetApplicationConfig -app_name "vim" -source_path "$directory/.config/vim" -destination_path "$HOME" -files ".vimrc"
}

RemoveVimConfig() {
  RemoveApplicationConfig -app_name "vim" -destination_path "$HOME" -files ".vimrc"
}

SetNeovimConfig() {
  SetApplicationConfig -app_name "neovim" -source_path "$directory/.config/nvim" -destination_path "$HOME/.config/nvim"
}

RemoveNeovimConfig() {
  RemoveApplicationConfig -app_name "neovim" -destination_path "$HOME/.config/nvim"
}

SetScriptsConfig() {
  SetApplicationConfig -app_name "scripts" -source_path "$directory/.script" -destination_path "$HOME/.script"
}

RemoveScriptsConfig() {
  RemoveApplicationConfig -app_name "scripts" -destination_path "$HOME/.script"
}

SetGitConfig() {
  SetApplicationConfig -app_name "git" -source_path "$directory/.gitconfig" -destination_path "$HOME" -files ".gitconfig"
}

RemoveGitConfig() {
  RemoveApplicationConfig -app_name "git" -destination_path "$HOME" -files ".gitconfig"
}

SetLazygitConfig() {
  SetApplicationConfig -app_name "lazygit" -source_path "$directory/.config/lazygit" -destination_path "$HOME/.config/lazygit"
}

RemoveLazygitConfig() {
  RemoveApplicationConfig -app_name "lazygit" -destination_path "$HOME/.config/lazygit"
}

SetCommitizenConfig() {
  SetApplicationConfig -app_name "commitizen" -source_path "$directory/.config/commitizen" -destination_path "$HOME" -files ".czrc"
}

RemoveCommitizenConfig() {
  RemoveApplicationConfig -app_name "commitizen" -destination_path "$HOME" -files ".czrc"
}

SetPythonConfig() {
  SetApplicationConfig -app_name "python" -source_path "$directory/.config/pip" -destination_path "$HOME/.config/pip"
}

RemovePythonConfig() {
  RemoveApplicationConfig -app_name "python" -destination_path "$HOME/.config/pip"
}

SetVisualStudioCodeConfig() {
  SetApplicationConfig -app_name "visual studio code" -source_path "$directory/.config/visual studio code" -destination_path "$HOME/Library/Application Support/Code/User" -extensions "json"
}

RemoveVisualStudioCodeConfig() {
  RemoveApplicationConfig -app_name "visual studio code" -destination_path "$HOME/Library/Application Support/Code/User" -extensions "json"
}

SetAllApplicationsConfig() {
  echo "Configuring all applications."
  SetFishConfig
  SetTmuxConfig
  SetVimConfig
  SetNeovimConfig
  SetScriptsConfig
  SetGitConfig
  SetLazygitConfig
  SetCommitizenConfig
  SetPythonConfig
  SetVisualStudioCodeConfig
}

RemoveAllApplicationsConfig() {
  echo "Removing all application configurations."
  RemoveFishConfig
  RemoveTmuxConfig
  RemoveVimConfig
  RemoveNeovimConfig
  RemoveScriptsConfig
  RemoveGitConfig
  RemoveLazygitConfig
  RemoveCommitizenConfig
  RemovePythonConfig
  RemoveVisualStudioCodeConfig
}

while true; do
  CheckInstallCompatibility
  Menu
  read -r -p "Enter your choice: " choice
  case $choice in
  1) InstallHomebrewPackages ;;
  2) InstallVisualStudioCodeExtensions ;;
  3) InstallAllPackages ;;
  4) UninstallHomebrewPackages ;;
  5) UninstallVisualStudioCodeExtensions ;;
  6) UninstallAllPackages ;;
  7) SetFishToDefaultShell ;;
  8) SetFishConfig ;;
  9) SetTmuxConfig ;;
  10) SetVimConfig ;;
  11) SetNeovimConfig ;;
  12) SetScriptsConfig ;;
  13) SetGitConfig ;;
  14) SetLazygitConfig ;;
  15) SetCommitizenConfig ;;
  16) SetPythonConfig ;;
  17) SetVisualStudioCodeConfig ;;
  18) SetAllApplicationsConfig ;;
  19) RemoveFishConfig ;;
  20) RemoveTmuxConfig ;;
  21) RemoveVimConfig ;;
  22) RemoveNeovimConfig ;;
  23) RemoveScriptsConfig ;;
  24) RemoveGitConfig ;;
  25) RemoveLazygitConfig ;;
  26) RemoveCommitizenConfig ;;
  27) RemovePythonConfig ;;
  28) RemoveVisualStudioCodeConfig ;;
  29) RemoveAllApplicationsConfig ;;
  q) break ;;
  *) echo "Invalid choice. Please try again." ;;
  esac
done
