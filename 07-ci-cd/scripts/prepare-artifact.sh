#!/usr/bin/env bash
set -euo pipefail
rm -rf artifact
mkdir -p artifact
cp -r app artifact/
cp appspec.yml artifact/
cp scripts/start_server.sh artifact/
cp scripts/stop_server.sh artifact/
zip -r artifact.zip artifact/*
echo "artifact.zip created"
