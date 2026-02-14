# Example Voting App

A simple distributed application running across multiple Docker containers.

This example is modified to run into AWS ECS using Fargate.

The Linux stack uses Python, Node.js, .NET Core (or optionally Java), with Redis for messaging and Postgres for storage.

The Docker images present on this repo are modified versions of the original repo [example-voting-app](https://github.com/dockersamples/example-voting-app/)
with the Docker, Docker-Compose and Kubernetes configurations.

This approach utilizes the AWS ECS for orchestrating the containers and bring the voting and result apps avaliable online.

![](assets/docs/rover.svg)
* Graph renderized with [im2nguyen/rover](https://github.com/im2nguyen/rover) *

## Getting started

First we need to construct the necessary resources for this application. Those are the resources:

* AWS Elasticache
  * Redis cluster
* AWS RDS
  * PostgreSQL
* AWS EC2
  * Application Load Balancer
  * Target Groups
  * Security Groups
* AWS ECR
* AWS ECS
  * Cluster
  * Task Definition
  * Service
* AWS IAM
  * Roles
  * Policies
* AWS CloudWatch
  * Log Group
* AWS System Manager (SSM)
  * Parameter Store

The existing default VPC and the available subnets will be used.

As this project is a example, the cost will be minimum if you destroy the resources after the use.

## Building the containers

After building the resources on AWS, you will need to deploy the application images. There are 3 and they source code,
functionality and more information about it can be found on the [original repository](https://github.com/dockersamples/example-voting-app/).

This version has some changes to the source and Dockerfiles:

### Result App

[The Dockerfile](docker/result/Dockerfile) has arguments to construct a full connection URI based on env variables:

```Dockerfile
ARG POSTGRES_HOST
ARG POSTGRES_USERNAME
ARG POSTGRES_PWD
ARG POSTGRES_DATABASE
ENV POSTGRES_HOST_STRING="postgres://${POSTGRES_USERNAME}:${POSTGRES_PWD}@${POSTGRES_HOST}/${POSTGRES_DATABASE}"
```

[The server.js](docker/result/server.js) has a modification to read the env variable POSTGRES_HOST_STRING:

```js
var pool = new pg.Pool({
  connectionString: process.env.POSTGRES_HOST_STRING
});
```

### Vote App

[The Dockerfile](docker/vote/Dockerfile) has arguments to construct a full connection URI based on env variables:

```Dockerfile
ARG REDIS_HOST
ENV REDIS_HOST=$REDIS_HOST
```

[The app.py](docker/vote/app.py) has a modification to read the env variable REDIS_HOST:

```py
g.redis = Redis(host=os.getenv('REDIS_HOST', "redis"), db=0, socket_timeout=5)
```

### Worker App

[The Dockerfile](docker/worker/Dockerfile) has arguments to construct a full connection URI based on env variables:

```Dockerfile
ARG REDIS_HOST
ENV REDIS_HOST=$REDIS_HOST

ARG POSTGRES_HOST
ARG POSTGRES_USERNAME
ARG POSTGRES_PWD
ARG POSTGRES_DATABASE

ENV POSTGRES_HOST=$POSTGRES_HOST
ENV POSTGRES_USERNAME=$POSTGRES_USERNAME
ENV POSTGRES_PWD=$POSTGRES_PWD
ENV POSTGRES_DATABASE=$POSTGRES_DATABASE
```

[The Program.cs](docker/worker/src/Worker/Program.cs) has a modification to read the env variable REDIS_HOST:

```
```

Grab the PostgreSQL username and PostgreSQL password from the SSM parameters created and create new environment variables
with the values, example:

```bash
export POSTGRES_USERNAME=postgres
export POSTGRES_PWD=OqRFQTqcm7kmUXXZPF824hwATkyz6yGy
```

After exporting the variables, run the [build.sh](build.sh) script. This script will get the output from Terraform for the
ECR repo URL, the PostgreSQL URL, the Redis URL, pass this values for the images with the username and password.
After that, a login into ECR will be made with the default AWS profile in the environment avaliable. After the login, the
three images will be pushed to the ECR repo.

After a few minutes, the ECS services will start to deploy new tasks and pull the images.
