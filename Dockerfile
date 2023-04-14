FROM ubuntu:rolling

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
  && apt-get install --no-install-recommends -q -y python3-sphinx \
  && bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)" \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/*
