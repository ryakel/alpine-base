#ARG BASE_IMAGE
#FROM ${BASE_IMAGE:-library/alpine:latest}
FROM alpine:latest
ENV S6_REL=2.2.0.1 S6_ARCH=aarch64 TZ=Etc/UTC

LABEL base.maintainer=rkelch
LABEL base.s6.rel=${S6_REL} base.s6.arch=${S6_ARCH}

RUN \
	apk add --no-cache --virtual=b-deps \
		curl \
		tar && \
	apk add --no-cache \
		bash \
		ca-certificates \
		coreutils \
		shadow \
		tzdata && \
		curl -L -s https://github.com/just-containers/s6-overlay/releases/download/v${S6_REL}/s6-overlay-${S6_ARCH}.tar.gz | tar xzf - -C / &&  \
	groupmod -g 1000 users && \
	useradd -u 1000 -U -d /config -s /bin/false alpine && \
	usermod -G users alpine && \
		mkdir -p \
		/app \
		/config && \
		apk del --purge b-deps && \
		rm -rf /tmp/*

COPY root/ /
VOLUME [ "/config" ]

ENTRYPOINT ["/init"]