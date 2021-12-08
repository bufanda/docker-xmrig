ARG ARCH=
FROM ${ARCH}alpine as prepare

ENV XMRIG_VERSION=v6.16.2
ENV XMRIG_URL=https://github.com/xmrig/xmrig.git
# 1. apk add git make cmake libstdc++ gcc g++ automake libtool autoconf linux-headers
# 2. git clone https://github.com/xmrig/xmrig.git
# 3. mkdir xmrig/build
# 4. cd xmrig/scripts && ./build_deps.sh && cd ../build
# 5. cmake .. -DXMRIG_DEPS=scripts/deps -DBUILD_STATIC=ON
# 6. make -j$(nproc)
RUN apk add git make cmake libstdc++ gcc g++ automake libtool autoconf linux-headers

RUN git clone ${XMRIG_URL} /xmrig && \
    cd /xmrig && git checkout ${XMRIG_VERSION}

RUN mkdir -p /xmrig/build && \
    cd /xmrig/scripts && ./build_deps.sh && cd ../build && \
    cmake .. -DXMRIG_DEPS=scripts/deps -DBUILD_STATIC=ON && \
    make -j$(nproc) 

ADD config.json /xmrig/build/conf/

FROM ${ARCH}alpine

ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/bufanda/docker-xmrig" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.schema-version="1.0.0-rc1"

COPY --from=prepare /xmrig/build/xmrig /xmrig/xmrig

ADD start.sh /

ENTRYPOINT [ "/start.sh" ]
