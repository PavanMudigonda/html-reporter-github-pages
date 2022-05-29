FROM ubuntu

RUN apt update && \
    apt reinstall runc

ENV ROOT=/app

RUN mkdir -p $ROOT

WORKDIR $ROOT
COPY ./entrypoint.sh /entrypoint.sh
RUN ["chmod", "+x", "/entrypoint.sh"]
ENTRYPOINT ["/entrypoint.sh"]

