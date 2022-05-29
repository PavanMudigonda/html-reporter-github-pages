FROM ubuntu

RUN apt update && \
    wget unzip && \
    apt reinstall runc

ENV ROOT=/app

RUN mkdir -p $ROOT

WORKDIR $ROOT
COPY ./entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
