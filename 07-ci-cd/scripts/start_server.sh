#!/bin/bash
cd /home/ec2-user/app/src
node index.js > app.log 2>&1 &
