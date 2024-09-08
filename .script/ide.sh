#!/bin/bash

CheckIDECompatibility() {
  if [[ $OSTYPE != "darwin"* ]]; then
    echo "This ide setup script does not support the current os."
    exit 1
  fi
}

CheckTmux() {
  if [[ -z "$TMUX" ]]; then
    echo "Please run this ide setup script inside tmux."
    exit 1
  fi
}

SetupIDELayout() {
  tmux split-window -v -l 30%
  tmux split-window -h -l 50%
  tmux select-pane -t 0
}

Main() {
  CheckIDECompatibility
  CheckTmux
  SetupIDELayout
}

Main
