
#!/bin/bash

ENV=$1
IMAGE=$2

echo "Deploying to $ENV..."

# Simulating environments using ports
case $ENV in
  dev)
    PORT=8081
    ;;
  qa)
    PORT=8082
    ;;
  prod)
    PORT=8083
    ;;
  *)
    echo "Invalid env"
    exit 1
    ;;
esac

docker rm -f app-$ENV || true

docker run -d -p $PORT:8080 --name app-$ENV $IMAGE

echo "$ENV deployed on port $PORT"
