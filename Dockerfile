FROM debian:stretch as builder

RUN apt-get update && \
    apt-get install -y wget mysql-client inotify-tools automake bzip2 \
    cmake make g++ gcc git openssl libssl-dev libgnutls28-dev libtool patch python gawk

COPY . /var/proxysql


WORKDIR /var/proxysql
RUN make 
RUN make install

FROM debian:stretch
COPY --from=builder /usr/bin/proxysql /usr/bin/proxysql
RUN apt-get update && \
    apt-get install -y mysql-client inotify-tools bzip2 openssl \
    libssl-dev libgnutls30

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

#CMD ["/bin/bash"]
