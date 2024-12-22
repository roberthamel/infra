#!/usr/bin/env bash
set -eEuo pipefail

if ! command -v make &> /dev/null; then
  echo "make could not be found. Please install make and try again."
  exit 1
fi

make up
