FROM alpine:latest as rootfs-prep
RUN \
 apk add --no-cache \
        bash \
        curl \
        tzdata \
        xz && \
 mkdir /rootfs && \
 curl -s -o \
	/rootfs.tar.gz -L \
	https://cloud-images.ubuntu.com/daily/server/minimal/daily/bionic/current/bionic-minimal-cloudimg-amd64-root.tar.xz && \
 tar xf \
        /rootfs.tar.gz -C \
        /rootfs && \
 curl -s -o \
	/overlay.tar.gz -L \
        https://github.com/just-containers/s6-overlay/releases/download/v2.1.0.0/s6-overlay-amd64.tar.gz && \
 tar xf \
        /overlay.tar.gz -C \
        /rootfs

FROM scratch
COPY --from=rootfs-prep /rootfs/ /
COPY base /
ENV DEBIAN_FRONTEND=noninteractive
RUN \
  apt-get update && \
  apt-get install -y \
	apt-utils \
	locales \
	netcat \
	gosu \
	tzdata && \
  groupmod -g 1000 users && \
  useradd -u 911 -U -d /config -s /bin/false container && \
  usermod -G users container && \
  apt-get clean  && \
  rm -rf /var/lib/apt/lists && \
  locale-gen en_US.UTF-8
  
ENTRYPOINT ["/init"]
