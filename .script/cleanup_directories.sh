#!/bin/bash

shopt -s dotglob

DeleteDirectoryContents() {
  local directory_paths=("$@")
  for directory_path in "${directory_paths[@]}"; do
    if [[ -d "$directory_path" ]]; then
      rm -rf "$directory_path"/*
    elif [[ -f "$directory_path" ]]; then
      rm -rf "$directory_path"
    fi
  done
}

Main() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    local macos_cleanup_dirs=(
      "$HOME/Downloads/"
      "$HOME/Movies/"
      "$HOME/Music/"
      "$HOME/Library/Caches/"
      "$HOME/Library/Logs/"
    )
    DeleteDirectoryContents "${macos_cleanup_dirs[@]}"
  elif [[ "$OSTYPE" == "msys" ]]; then
    local windows_cleanup_dirs=(
      "$HOME/Downloads/"
      "$HOME/Videos/"
      "$HOME/Music/"
    )
    DeleteDirectoryContents "${windows_cleanup_dirs[@]}"
  else
    echo "This cleanup script does not support the current os."
    exit 1
  fi
}

Main
