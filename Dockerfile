FROM ubuntu:16.04
MAINTAINER sungwon kim <sungwon.pino@gmail.com>

RUN     apt-get update \
            && apt-get install -y \
            git \
            wget \
            vim \
            openssh-server \
            libdata-dumper-simple-perl 

# To avoid annoying "perl: warning: Setting locale failed." errors,
# do not allow the client to pass custom locals, see:
# http://stackoverflow.com/a/2510548/15677
RUN sed -i 's/^AcceptEnv LANG LC_\*$//g' /etc/ssh/sshd_config

#RUN /usr/sbin/useradd --comment "Git" --shell /bin/bash git
RUN adduser --disabled-password --gecos ""  git
RUN su - git

USER git

WORKDIR /home/git

RUN mkdir -p /home/git/bin && \
        git clone git://github.com/sitaramc/gitolite  && \
        gitolite/install -ln /home/git/bin && \
        mkdir -p /home/git/repositories

USER root

EXPOSE 22 80 443

# patch sshd_config for fast login
RUN echo "UseDNS no" >> /etc/ssh/sshd_config

VOLUME ["/home/git/repositories"]

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-D"]

COPY entrypoint.sh /entrypoint.sh
COPY setup.sh /setup.sh
            

