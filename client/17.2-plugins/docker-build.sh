#!/bin/bash
set -e

TAG="17.2-plugins"

docker build -t wcen/bareos-fd:${TAG} .
