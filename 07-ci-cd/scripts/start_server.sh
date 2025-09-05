#!/usr/bin/env bash
cd /home/ec2-user/app/app || exit 1
# stop previous process if exists
pkill -f server.js || true
nohup node server.js > /home/ec2-user/app/server.log 2>&1 &
