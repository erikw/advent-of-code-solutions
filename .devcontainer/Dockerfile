# Ref: https://hub.docker.com/r/microsoft/devcontainers-universal
FROM mcr.microsoft.com/devcontainers/universal:2

# Keep in sync with Brewfile.
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install octave z3 multitime
