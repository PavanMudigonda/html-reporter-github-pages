FROM ubuntu

RUN apt update && \
    apt add --no-cache bash wget unzip && \
    rm -rf /var/cache/apt/* \
    apt reinstall runc

ENV ROOT=/app

RUN mkdir -p $ROOT

WORKDIR $ROOT
COPY ./entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
