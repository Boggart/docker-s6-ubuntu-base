FROM scratch
ADD https://cloud-images.ubuntu.com/daily/server/minimal/daily/bionic/current/bionic-minimal-cloudimg-amd64-root.tar.xz /
ADD https://github.com/just-containers/s6-overlay/releases/download/v2.1.0.0/s6-overlay-amd64.tar.gz /tmp
RUN 
COPY base /
RUN \
  tar xzf /tmp/s6-overlay-amd64.tar.gz -C / --exclude="./bin" && \
  tar xzf /tmp/s6-overlay-amd64.tar.gz -C /usr ./bin &&
  rm /tmp/s6-overlay-amd64.tar.gz && \
  apt-get install -y \
	apt-utils \
	locales \
	tzdata && \
  locale-gen en_US.UTF-8 && \
  groupmod -g 1000 users && \
  useradd -u 911 -U -d /config -s /bin/false container && \
  usermod -G users container
ENTRYPOINT ["/init"]
