#!/bin/sh
echo "Starting Docker Daemon from dockerd-cmd.sh"
dockerd --host=unix:///var/run/docker.sock --host=tcp://0.0.0.0:2375 --storage-driver=vfs&
sleep 3; echo "Starting minikube"; minikube start
echo "Sleeping forever!"; while :; do read; done
