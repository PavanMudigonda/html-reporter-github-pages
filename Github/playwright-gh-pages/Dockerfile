FROM alpine:latest

RUN echo $RELEASE && \
    apk update && \
    apk add --no-cache bash wget unzip && \
    rm -rf /var/cache/apk/*

RUN mkdir -p $ROOT

WORKDIR $ROOT
COPY ./entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
