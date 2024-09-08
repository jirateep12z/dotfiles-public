#!/bin/bash

CheckDockResizeCompatibility() {
  if [[ $OSTYPE != "darwin"* ]]; then
    echo "This resize dock script does not support the current os."
    exit 1
  fi
}

CheckDockResizeArguments() {
  if [[ $# -ne 1 ]]; then
    echo "Usage: resize_dock <percentage>"
    exit 1
  fi
}

ValidateDockTileSize() {
  local dock_tile_size="$1"
  if [[ ! "$dock_tile_size" =~ ^[0-9]+$ || "$dock_tile_size" -lt 20 || "$dock_tile_size" -gt 80 ]]; then
    echo "Please enter a valid dock tile size between 20 and 80."
    exit 1
  fi
}

ApplyDockTileSize() {
  local dock_tile_size="$1"
  defaults write com.apple.dock tilesize -int "$dock_tile_size"
  killall Dock
}

Main() {
  local dock_tile_size="$1"
  CheckDockResizeCompatibility
  CheckDockResizeArguments "$@"
  ValidateDockTileSize "$dock_tile_size"
  ApplyDockTileSize "$dock_tile_size"
}

Main "$@"
