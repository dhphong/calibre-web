FROM lsiobase/ubuntu:bionic

# set version label
ARG BUILD_DATE
ARG VERSION
ARG CALIBREWEB_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="chbmb"

RUN \
 echo "**** install build packages ****" && \
 apt-get update && \
 apt-get install -y \
	git \
	libldap2-dev \
	libsasl2-dev \
	rsync \
	python3-pip && \
 echo "**** install runtime packages ****" && \
 apt-get install -y \
	imagemagick \
	libnss3 \
	libxcomposite1 \
	libxslt1.1 \
	libldap-2.4-2 \
	libsasl2-2 \
	python3-minimal \
	unrar && \
 echo "**** install calibre-web ****" && \
 mkdir -p /app/calibre-web && \
 git clone https://github.com/dhphong/calibre-web.git /app/calibre-web && \
 cd /app/calibre-web && \
 pip3 install --no-cache-dir -U -r \
	requirements.txt && \
 pip3 install --no-cache-dir -U -r \
	optional-requirements.txt && \
 echo "***install kepubify" && \
 if [ -z ${KEPUBIFY_RELEASE+x} ]; then \
    KEPUBIFY_RELEASE=$(curl -sX GET "https://api.github.com/repos/pgaskin/kepubify/releases/latest" \
    | awk '/tag_name/{print $4;exit}' FS='[""]'); \
 fi && \
 curl -o \
 /usr/bin/kepubify -L \
	https://github.com/pgaskin/kepubify/releases/download/${KEPUBIFY_RELEASE}/kepubify-linux-64bit && \
 rsync -aP --remove-source-files root/defaults / && \
 rsync -aP --remove-source-files root/etc / && \
 echo "**** cleanup ****" && \
 apt-get -y purge \
	git \
	libldap2-dev \
	libsasl2-dev \
    rsync \
	python3-pip && \
 apt-get -y autoremove && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# ports and volumes
EXPOSE 8083
VOLUME /books /config
