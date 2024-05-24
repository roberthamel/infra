#!/usr/bin/env bash
set -Eeuo pipefail

start_time=$(date +%s)

_log() {
  echo -e "🟢 \033[1;33m${1}\033[0m"
}

get_next_vm_id() {
  local MAX_ID=$(qm list | awk 'NR>1 && $3 != "template" {print $1}' | sort -n | tail -1)
  local NEXT_ID=$((MAX_ID + 1))
  echo $NEXT_ID
}

clone_and_start_vm() {
  local TEMPLATE_VM_ID=100
  local NEW_VM_ID=$1

  _log "Cloning template VM..."
  echo -n "VM Name: "
  read NEW_VM_NAME
  qm clone $TEMPLATE_VM_ID $NEW_VM_ID --full=true --name=$NEW_VM_NAME

  _log "Resizing disk..."
  qm resize $NEW_VM_ID scsi0 32G

  _log "Starting cloned VM..."
  qm start $NEW_VM_ID
}

clone_and_start_vm $(get_next_vm_id)
end_time=$(date +%s)
elapsed_time=$(($end_time - $start_time))
minutes=$(($elapsed_time / 60))
seconds=$(($elapsed_time % 60))
echo "Elapsed time: $minutes minute(s) $seconds second(s)"
echo "exit $?"
