#!/bin/bash

if [ $# -eq 0 ] 
 then
  echo "Need args!";
  exit;
fi

if [ $1 = "home" ]
 then
  umount /Volumes/share_sshfs;
  mkdir /Volumes/share_sshfs;
  sshfs -p 22 root@192.168.0.14:/mnt/share /Volumes/share_sshfs/ -oauto_cache,reconnect,defer_permissions,noappledouble,negative_vncache,volname=share;
  exit;
fi
