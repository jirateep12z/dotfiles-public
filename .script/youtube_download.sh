#!/bin/bash

CheckYoutubeDownloadCompatibility() {
  if [[ "$OSTYPE" != "darwin"* && "$OSTYPE" != "msys" ]]; then
    echo "This youtube download script does not support the current os."
    exit 1
  fi
}

CheckYoutubeDownloadDependencies() {
  local required_commands="yt-dlp ffmpeg"
  for command in $required_commands; do
    if [[ ! -x "$(command -v "$command")" ]]; then
      echo "$command is required to run this youtube download script."
      exit 1
    fi
  done
}

ValidateYoutubeUrl() {
  if [[ "$youtube_input" =~ ^(http(s)?:\/\/)?(www\.)?youtube\.com\/watch.* ]]; then
    if [[ "$youtube_input" =~ ^.*\?v=[A-Za-z0-9_-]{11}$ ]]; then
      echo "Youtube video url detected."
    elif [[ "$youtube_input" =~ ^.*\&list=[A-Za-z0-9_-].* ]]; then
      echo "Youtube playlist url detected."
    fi
    youtube_id="${youtube_input#*v=}"
  elif [[ "$youtube_input" =~ ^[A-Za-z0-9_-]{11}$ ]]; then
    echo "Youtube video id detected."
    youtube_id="$youtube_input"
  elif [[ "$youtube_input" =~ ^.*\&list=[A-Za-z0-9_-].* ]]; then
    echo "Youtube playlist id detected."
    youtube_id="$youtube_input"
  else
    echo "Please enter a valid youtube video id or url."
    exit 1
  fi
}

GetYoutubeDownloadDirectory() {
  local download_type="$1"
  local youtube_download_dir=""
  if [[ "$download_type" =~ ^[vV]$ ]]; then
    if [[ $OSTYPE == "darwin"* ]]; then
      youtube_download_dir="$HOME/Movies"
    elif [[ $OSTYPE == "msys" ]]; then
      youtube_download_dir="$HOME/Videos"
    fi
  elif [[ "$download_type" =~ ^[aA]$ ]]; then
    if [[ $OSTYPE == "darwin"* ]]; then
      youtube_download_dir="$HOME/Music"
    elif [[ $OSTYPE == "msys" ]]; then
      youtube_download_dir="$HOME/Music"
    fi
  else
    echo "Please enter video or audio (v/a) for youtube download."
    exit 1
  fi
  echo "$youtube_download_dir"
}

DownloadYoutubeContent() {
  local youtube_id="$1"
  local download_type="$2"
  local youtube_download_dir="$3"
  if [[ "$download_type" =~ ^[vV]$ ]]; then
    yt-dlp --merge-output-format mp4 -f bestvideo+bestaudio[ext=m4a]/best "https://www.youtube.com/watch?v=$youtube_id" -o "$youtube_download_dir/%(id)s.%(ext)s"
  elif [[ "$download_type" =~ ^[aA]$ ]]; then
    yt-dlp -f bestaudio[ext=m4a]/best "https://www.youtube.com/watch?v=$youtube_id" -o "$youtube_download_dir/%(id)s.%(ext)s"
  else
    echo "Please enter video or audio (v/a) for youtube download."
    exit 1
  fi
}

OpenYoutubeDownloadDirectory() {
  local youtube_download_dir="$1"
  local open_command=""
  if [[ $OSTYPE == "darwin"* ]]; then
    open_command="open"
  elif [[ $OSTYPE == "msys" ]]; then
    open_command="start"
  fi
  "$open_command" "$youtube_download_dir"
}

Main() {
  local youtube_download_dir=""
  CheckYoutubeDownloadCompatibility
  CheckYoutubeDownloadDependencies
  read -r -p "Enter youtube video id or url: " youtube_input
  ValidateYoutubeUrl "$youtube_input"
  read -r -p "Download youtube video or audio? (v/a): " download_type
  youtube_download_dir=$(GetYoutubeDownloadDirectory "$download_type")
  DownloadYoutubeContent "$youtube_id" "$download_type" "$youtube_download_dir"
  OpenYoutubeDownloadDirectory "$youtube_download_dir"
}

Main
