#!/usr/bin/env bash

# Old convenient build script, kept for sentimental reasons.

REPO=$(terraform output -raw url_ecr_repo)
REDIS_HOST=$(terraform output -raw url_redis)
POSTGRES_HOST=$(terraform output -raw url_postgres)

if [[ -z "${POSTGRES_USERNAME}" ]] || [[ -z "${POSTGRES_PWD}" ]]; then
  echo "Please set the environment variables for POSTGRES_USERNAME and POSTGRES_PWD before executing this script."
  exit 1;
fi

echo "Building images"

docker build ./docker/vote -t "${REPO}":vote --build-arg REDIS_HOST="${REDIS_HOST}"

docker build ./docker/result -t "${REPO}":result --build-arg POSTGRES_HOST="${POSTGRES_HOST}" \
 --build-arg POSTGRES_USERNAME="${POSTGRES_USERNAME}" --build-arg POSTGRES_PWD="${POSTGRES_PWD}"

docker build ./docker/worker -t "${REPO}":worker --build-arg POSTGRES_HOST="${POSTGRES_HOST}" \
 --build-arg POSTGRES_USERNAME="${POSTGRES_USERNAME}" --build-arg POSTGRES_PWD="${POSTGRES_PWD}" \
 --build-arg REDIS_HOST="${REDIS_HOST}"

echo "Login into ECR"

aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin "${REPO}"

echo "Push the images to ECR"

docker push "${REPO}":vote
docker push "${REPO}":result
docker push "${REPO}":worker
