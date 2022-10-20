# FROM debian:buster-slim, ubuntu works but the debian does not work
FROM ubuntu
MAINTAINER Endless Services Team <services@endlessm.com>
LABEL version="0.1"

RUN apt-get update && \
    apt-get install -y \
        gir1.2-ostree-1.0 \
        flatpak \
        ostree \
        git \
        libmagic-dev \
        libevent-dev \
        libffi-dev \
        python3 \
        gcc \
        musl-dev \
        make \
        python3-dev \
        python3-cairo \
        python3-gi \
        python3-pip \
        python-all-dev \
        # This packages do not exist on ubuntu
	    # python-gevent \
        # python-gevent-websocket \
        && \
    apt-get clean

RUN apt-get upgrade

ENV INSTALL_DIR="/opt/ostree-upload-server"

RUN mkdir -p $INSTALL_DIR
WORKDIR $INSTALL_DIR
COPY requirements.txt $INSTALL_DIR

RUN pip3 install --no-cache-dir -r $INSTALL_DIR/requirements.txt --only-binary cffi

EXPOSE 5000

# XXX: Use static/unique UID/GID to ensure consistency in mounted volume handling
RUN groupadd -r -g 800 ostree-server && \
    useradd -r -u 800 -g 800 ostree-server

COPY . $INSTALL_DIR

# ARG USER_ID=1000
# ARG GROUP_ID=1000

# RUN groupadd --system --gid ${GROUP_ID} MY_GROUP && \
#     useradd --system --uid ${USER_ID} --gid MY_GROUP --home /home/MY_USER --shell /sbin/nologin MY_USER

RUN chown -R ostree-server:ostree-server $INSTALL_DIR && \
    chmod +x $INSTALL_DIR/ostree-upload-server.py

RUN mkdir /repo && \
    chown -R ostree-server:ostree-server /repo

#USER ostree-server

#ENTRYPOINT ["/usr/bin/python3", "ostree-upload-server.py"]