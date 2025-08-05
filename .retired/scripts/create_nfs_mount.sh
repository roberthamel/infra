#!/usr/bin/env bash
set -eEuo pipefail
start_time=$(date +%s)

print_elapsed_time() {
  end_time=$(date +%s)
  elapsed_time=$(($end_time - $start_time))
  minutes=$(($elapsed_time / 60))
  seconds=$(($elapsed_time % 60))
  echo "Elapsed time: $minutes minute(s) $seconds second(s)"
  echo "exit $?"
}

# Function to echo each command before it's executed
trace() {
  echo "+ $@"
  "$@"
}

# be sure hostname is set as expected
host=$(hostname)
storage_host="mini"
if [[ "$host" =~ "$storage_host" ]]; then
  echo "Same machine detected, exiting"
  exit 0
fi
storage_path="/Volumes/2TBnvmeC/$host"

# make sure user is root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

trace apt update
trace apt install -y nfs-common
trace mkdir -p /nfs/$storage_host/$host
trace chown nobody:nogroup /nfs/$storage_host/$host
trace mount $storage_host.home:/Volumes/2TBnvmeC/$host /nfs/$storage_host/$host
trace bash -c "echo \"$storage_host.home:/Volumes/2TBNvmeC/$host   /nfs/$storage_host/$host     nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0\" >> /etc/fstab"
print_elapsed_time
