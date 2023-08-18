# syntax=docker/dockerfile:1
ARG VERSION="bookworm-backports"
FROM debian:${VERSION}


ENV VERSION="bookworm-backports"
ENV PACKAGES="binfmt-support build-essential lsof sudo util-linux fdisk"
ENV BPO="qemu-user-static"

RUN set -ex \
    && apt-get update \
    && apt-get install --no-install-recommends --yes ${PACKAGES} \
    && apt-get install --no-install-recommends --yes -t ${VERSION} ${BPO} \
    && apt -y autoremove \
    && rm -rf /var/lib/apt/lists/*

COPY . /CustoPiZer

ENTRYPOINT [ "/bin/bash" ]
CMD [ "/CustoPiZer/customize" ]
