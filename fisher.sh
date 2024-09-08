#!/usr/bin/env fish

set directory (dirname (status -f))

function CheckInstallCompatibility
  if test "$(string lower (uname))" != "darwin"
    echo "This install script does not support the current os."
    exit 1
  end
end

function CheckFishShell
  if test -z "$FISH_VERSION"
    echo "Please run this script inside fish shell."
    exit 1
  end
end

function InstallFisher
  if not type -q fisher
    echo "Fisher is not installed. Installing..."
    curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
  end
end

function InstallFisherPlugins
  echo "Installing fisher plugins."
  while read -l plugin
    fisher install $plugin
  end < "$directory/.requirement/fisher.txt"
end

function InstallNodeJS
  if not type -q nvm
    echo "Fihser plugins is not installed. Installing..."
    InstallFisherPlugins
  end
  echo "Installing node.js lts version."
  nvm install lts
  echo "Using node.js lts version."
  nvm use lts
  echo "Using default node.js version."
  set --universal nvm_default_version lts
end

function InstallNPMPackages
  if not type -q npm
    echo "Node.js is not installed. Installing..."
    SetupNodeJS
  end
  while read -l package
    npm install -g $package
  end < "$directory/.requirement/npm.txt"
end

function Main
  CheckInstallCompatibility
  CheckFishShell
  InstallFisher
  InstallFisherPlugins
  InstallNodeJS
  InstallNPMPackages
end

Main
