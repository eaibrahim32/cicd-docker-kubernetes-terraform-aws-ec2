#!/bin/bash
echo "Restarting containers..."
docker-compose down
docker-compose up -d
echo "Done. Current status:"
docker-compose ps
