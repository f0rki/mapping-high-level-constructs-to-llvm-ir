FROM ubuntu:rolling

WORKDIR /app

# Set these using: docker build --build-arg NATIVE_UID=$(id -u ${USER}) --build-arg NATIVE_GID=$(id -g ${USER}) -t llvmir .
ARG NATIVE_UID=1000
ARG NATIVE_GID=1000

# The default user created by ubuntu:rolling is ubuntu(1000):ubuntu(1000), which we'll reuse.
ARG DOCKER_UID=ubuntu
ARG DOCKER_GID=ubuntu

# Recreate docker user:group as our host user:group (to avoid getting output files owned by root).
# See https://jtreminio.com/blog/running-docker-containers-as-current-host-user/ for more information.
RUN \
if [ ${NATIVE_UID:-0} -ne 0 ] && [ ${NATIVE_GID:-0} -ne 0 ]; then \
  userdel -f ${DOCKER_UID} &&\
  if getent group ${DOCKER_GID}; then groupdel ${DOCKER_GID}; fi &&\
    groupadd -g ${NATIVE_GID} ${DOCKER_GID} &&\
    useradd -l -u ${NATIVE_GID} -g ${DOCKER_GID} ${DOCKER_GID} &&\
    install -d -m 0755 -o ${DOCKER_UID} -g ${DOCKER_GID} /app/_build &&\
    chown --changes --silent --no-dereference --recursive --from=`id -u ${DOCKER_UID}`:`id -g ${DOCKER_GID}` ${NATIVE_UID}:${NATIVE_GID} /app/_build \
;fi

# Disable interactive features in Debian `apt` and `apt-get` tools.
ARG DEBIAN_FRONTEND=noninteractive

# Install the things that we actually need.
RUN \
  apt-get update &&\
  apt-get install --no-install-recommends -q -y make python3-sphinx python3-sphinx-rtd-theme &&\
  bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)" &&\
  apt-get clean -y &&\
  rm -rf /var/lib/apt/lists/*

USER ${DOCKER_UID}:${DOCKER_GID}
