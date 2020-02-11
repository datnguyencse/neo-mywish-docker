#!/bin/bash
#
# Start a Docker container which runs the four consensus nodes. If it is
# already running, it will be destroyed first.
#
CONTAINER_NAME="neo-mywish"
CONTAINER=$(docker ps -aqf name=$CONTAINER_NAME)

if [ -n "$CONTAINER" ]; then
	echo "Stopping container named $CONTAINER_NAME"
	docker stop $CONTAINER_NAME 1>/dev/null
	echo "Removing container named $CONTAINER_NAME"
	docker rm $CONTAINER_NAME 1>/dev/null
fi

echo "Starting container..."
docker run -d --name $CONTAINER_NAME -p 20332:20332/tcp -p 30332:30332/tcp -h $CONTAINER_NAME $CONTAINER_NAME
