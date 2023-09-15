FROM rust:1-alpine3.18 

RUN apk update && \
    apk upgrade && \
    apk add --no-cache \
      gcompat make

WORKDIR /app-home

ENTRYPOINT [ "make" ]
CMD [ "test" ]
