#!/bin/bash
volume_path="/Volumes/share_sshfs"

if [ $# -eq 0 ] 
 then
  echo "Need args!";
  exit;
fi

if [ $1 = "home" ]
 then
  if [ -d "$volume_path" ]; then
   umount "$volume_path";
   echo "Volume already exists, unmounting it first..."
  fi
  mkdir "$volume_path";
  sshfs -p 22 root@192.168.0.14:/mnt/share "$volume_path" -oauto_cache,reconnect,defer_permissions,noappledouble,negative_vncache,volname=share;
  echo "Mounted!"
  exit;
fi
