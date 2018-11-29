#!/bin/bash
set -e

TAG="latest"

docker build -t wcen/bareos-fd-mysql .
