
FROM golang:1.10-alpine

ENV WORKING_DIR /gallactic

RUN addgroup guser && \
    adduser -S -G guser guser

RUN mkdir -p $WORKING_DIR && \
    chown -R guser:guser $WORKING_DIR

RUN apk add --no-cache bash curl jq rust cargo


ENV GOPATH /go
ENV PATH "$PATH:/go/bin"
RUN mkdir -p /go/src/github.com/gallactic/gallactic/ && \
    apk add --no-cache build-base git && \
    cd /go/src/github.com/gallactic/gallactic/ && \
    git clone https://github.com/gallactic/gallactic/ . && \
    git checkout develop && \
    make && \
    cd - && \
    rm -rf /go/src/ && \
    apk del build-base git rust


EXPOSE 45566
EXPOSE 1337

VOLUME $WORKING_DIR

ENTRYPOINT ["gallactic"]

CMD ["init", "-w="$WORKING_DIR]