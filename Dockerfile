FROM alpine:3.9

RUN echo 'http://dl-cdn.alpinelinux.org/alpine/v3.9/main' >> /etc/apk/repositories
RUN echo 'http://dl-cdn.alpinelinux.org/alpine/v3.9/community' >> /etc/apk/repositories

RUN apk update && apk --no-cache --update add \
  bash \
  curl \
  ca-certificates \
  mongodb-tools \
  mongodb \
  python3 \
  htop \
  py3-pip \
  && pip3 install --upgrade pip \
  && pip3 install \
  awscli \
  && rm -rf /var/cache/apk/*

ENV PROJECT_WORKDIR=/home/mongo
WORKDIR $PROJECT_WORKDIR/

COPY . $PROJECT_WORKDIR/
RUN chmod +x $PROJECT_WORKDIR/mongoexport.sh

CMD [ "./mongoexport.sh" ]
