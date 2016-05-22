FROM debian:stable

MAINTAINER Stephen Newhouse <stephen.j.newhouse@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

# update and get some things
RUN apt-get update --fix-missing && \
    apt-get upgrade -y && \
    apt-get install -y \
    wget \
    bzip2 \
    ca-certificates \
    libglib2.0-0 \
    libxext6 \
    libsm6 \
    libxrender1 \
    git \
    mercurial \
    subversion \
    make \
    cmake \
    gcc \
    gpp \
    build-essential \
    zlib1g-dev \
    patch \
    perl \
    libextutils-pkgconfig-perl \
    byacc \
    wget \
    curl \
    grep \
    sed \
    dpkg \
    debconf \
    unzip \
    tree \
    libc6 \
    llvm \
    locales \
    time \
    sudo && \
    apt-get update --fix-missing && \
    apt-get upgrade -y && \
    apt-get autoremove -y && \
    apt-get autoclean && \
    apt-get clean && \
    apt-get purge && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# configure locales
RUN dpkg-reconfigure locales && \
  locale-gen C.UTF-8 && \
  /usr/sbin/update-locale LANG=C.UTF-8 && \
  echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && \
  locale-gen

# Set default locale for the environment
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# User set up
RUN useradd -m -U -s /bin/bash ngseasy && \
  cd /home/ngseasy && \
  chown ngseasy:ngseasy /home/ngseasy && \
  usermod -aG sudo ngseasy && \
# echo 'export PATH=/home/ngseasy/anaconda2/bin:$PATH' > /etc/profile.d/conda.sh && \
  groupadd docker && \
  usermod -aG docker ngseasy && \
# Ensure permissions are set for update in place by arbitrary users
# From: https://github.com/chapmanb/bcbio-nextgen/blob/master/Dockerfile#L68
  find /usr/local -perm /u+x -execdir chmod a+x {} \; && \
  find /usr/local -perm /u+w -execdir chmod a+w {} \; && \
  chown -R ngseasy:ngseasy /home/ngseasy/

# switch to ngseasy user
USER ngseasy

# get ngseasy_conda_install script
ADD ngseasy_conda_install.sh /home/nsgeasy/ngseasy_conda_install.sh

# install conda and ngs tools
RUN /bin/bash /home/nsgeasy/ngseasy_conda_install.sh

# volumes
VOLUME /home/ngseasy
VOLUME /home/ngseasy/reference_genomes
VOLUME /home/ngseasy/ngs_projects
VOLUME /home/ngseasy/ngs_projects/fastq
VOLUME /home/ngseasy/scratch
VOLUME /home/ngseasy/anaconda2/bin

# set Home
ENV HOME /home/ngseasy
WORKDIR /home/ngseasy

# Expose for future
EXPOSE 80
EXPOSE 8080

## gatk
ADD GenomeAnalysisTK.jar /home/ngseasy/anaconda2/bin/gatk-3.5.jar

# starting point
CMD [ "/bin/bash" ]