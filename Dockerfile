FROM ghcr.io/linuxserver/baseimage-alpine:3.12

# set version label
ARG BUILD_DATE
ARG VERSION
ARG RSNAPSHOT_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="nemchik"

RUN \
 echo "**** install build packages ****" && \
 apk add --no-cache --virtual=build-dependencies \
	curl && \
 echo "**** install runtime packages ****" && \
 if [ -z ${RSNAPSHOT_VERSION+x} ]; then \
	RSNAPSHOT_VERSION=$(curl -sL "http://dl-cdn.alpinelinux.org/alpine/v3.13/main/x86_64/APKINDEX.tar.gz" | tar -xz -C /tmp \
	&& awk '/^P:rsnapshot$/,/V:/' /tmp/APKINDEX | sed -n 2p | sed 's/^V://'); \
 fi && \
 apk add --no-cache \
	openssh \
	rsnapshot==${RSNAPSHOT_VERSION} \
	rsync && \
 echo "**** cleanup ****" && \
 apk del --purge \
	build-dependencies && \
 rm -rf \
    /root/.cache \
    /tmp/*

# copy local files
COPY root/ /

# ports and volumes
VOLUME /config
