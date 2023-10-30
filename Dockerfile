FROM ubuntu:latest as n2n-builder
LABEL previous-stage=nodevpn-builder

# prepare builder
RUN apt update && apt install -y make gcc liblzo2-dev cmake autoconf pkg-config git
# do make
RUN mkdir -p /build/n2n

COPY . /build/n2n

RUN cd /build/n2n && git checkout 3.0-stable

RUN cd /build/n2n && ./autogen.sh && CFLAGS='-static' LDFLAGS='-static' ./configure && make && make install

FROM busybox:latest
COPY --from=n2n-builder /build/n2n/supernode /
COPY --from=n2n-builder /build/n2n/edge /
CMD ["/bin/sh"]

