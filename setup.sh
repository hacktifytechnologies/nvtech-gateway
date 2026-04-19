#!/bin/bash
cd "$(dirname "$0")"
if docker compose version >/dev/null 2>&1; then
    docker compose up -d --build
else
    docker-compose up -d --build
fi
