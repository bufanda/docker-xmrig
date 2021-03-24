FROM alpine as prepare

ENV XMRIG_VERSION=6.10
ENV XMRIG_URL=https://github.com/xmrig/xmrig/releases/download/v${XMRIG_VERSION}}/xmrig-${XMRIG_VERSION}-linux-static-x64.tar.gz

ADD ${XMRIG_URL} /

RUN mkdir -p /xmrig/conf \
    tar -xf /xmrig-${XMRIG_VERSION}-linux-static-x64.tar.gz -C /xmrig --strip-components=1

ADD config.json /xmrig/conf/

FROM alpine

ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/bufanda/docker-xmrig" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.schema-version="1.0.0-rc1"

COPY --from=prepare /xmrig /xmrig

ADD start.sh /

ENTRYPOINT [ "/start.sh" ]
