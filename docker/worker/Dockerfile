FROM mcr.microsoft.com/dotnet/core/sdk:8.0 as builder

WORKDIR /Worker
COPY src/Worker/Worker.csproj .
RUN dotnet restore

COPY src/Worker/ .
RUN dotnet publish -c Release -o /out Worker.csproj

# app image
FROM mcr.microsoft.com/dotnet/core/runtime:3.1

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

WORKDIR /app
ENTRYPOINT ["dotnet", "Worker.dll"]

COPY --from=builder /out .
