FROM jenkinsci/jenkins:lts
LABEL maintainer="john.lin@ringcentral.com"

USER root
ARG DOCKER_COMPOSE_VERSION=1.23.2

#RUN sed -i "s/deb.debian.org/mirrors.163.com/g" /etc/apt/sources.list && \
#    sed -i "s/security.debian.org/mirrors.163.com/g" /etc/apt/sources.list

RUN apt-get update && \
    apt-get install -qy \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg2 \
        software-properties-common && \
    rm -rf /var/lib/apt/lists/*

# Install docker
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" && \
    apt-get update && \
    apt-get install -qy docker-ce docker-ce-cli containerd.io
# Install docker
RUN curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

# add the jenkins user to the docker group so that sudo is not required to run docker commands
RUN groupmod docker && gpasswd -a jenkins docker

USER jenkins