#!/bin/bash

TAG=$(date '+%Y%m%dT%H%M%S')
docker build -t bjing/plutus-dev-container:$TAG .
docker tag bjing/plutus-dev-container:$TAG bjing/plutus-dev-container:latest
