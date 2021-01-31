FROM alpine:3.12 as builder

ARG CXXFLAGS="-DSTACK_TRACE:BOOL -DELPP_FEATURE_CRASH_LOG"
ARG HAVEN_VERSION=v1.2.0d

RUN apk --no-cache add git 
RUN apk --no-cache add bash
RUN apk --no-cache add build-base
RUN apk --no-cache add patch
RUN apk --no-cache add cmake 
RUN apk --no-cache add openssl-dev
RUN apk --no-cache add linux-headers
RUN apk --no-cache add zeromq-dev
RUN apk --no-cache add libexecinfo-dev
RUN apk --no-cache add libunwind-dev

RUN wget https://dl.bintray.com/boostorg/release/1.72.0/source/boost_1_72_0.tar.gz
RUN tar -xvf boost_1_72_0.tar.gz
WORKDIR /boost_1_72_0
RUN ./bootstrap.sh
RUN ./b2 install

WORKDIR /
RUN git clone --recursive --depth 1 --branch ${HAVEN_VERSION} --single-branch https://github.com/haven-protocol-org/haven-offshore.git 
WORKDIR /haven-offshore
RUN ./build-haven.sh release-static-linux-armv7 -j${nproc}

FROM alpine:3.12  as runner

RUN apk update
RUN apk --no-cache add \
  libexecinfo \
  libzmq \
  boost-system \
  boost-thread \
  boost-chrono \
  boost-regex \
  boost-serialization \
  boost-locale \
  boost-date_time \
  boost-program_options \
  boost-filesystem \
  bash \
  su-exec

COPY --from=builder /haven-offshore/monero/build/release/bin/havend /usr/local/bin/havend

RUN chmod a+x /usr/local/bin/havend
ADD ./docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
RUN chmod a+x /usr/local/bin/docker_entrypoint.sh

EXPOSE 17749 17750

ENTRYPOINT ["/usr/local/bin/docker_entrypoint.sh"]