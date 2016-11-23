# Docker image for building and testing tkwant

# Debian Jessie image released 2016 May 03.
FROM debian@sha256:32a225e412babcd54c0ea777846183c61003d125278882873fb2bc97f9057c51

MAINTAINER Kwant developers <authors@kwant-project.org>

# Uses parts of jupyter/base-notebook Dockerfile, which is:
# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

ENV DEBIAN_FRONTEND noninteractive
RUN REPO=http://cdn-fastly.deb.debian.org \
 && echo "deb $REPO/debian jessie main\ndeb $REPO/debian-security jessie/updates main" > /etc/apt/sources.list \
 && apt-get update && apt-get -yq dist-upgrade \
 && apt-get install -yq --no-install-recommends \
     git g++ make patch pkg-config wget sudo ca-certificates bzip2 locales \
     # Additional tools for running CI
     file rsync openssh-client\
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

ENV CONDA_DIR /opt/conda
ENV PATH $CONDA_DIR/bin:$PATH
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

RUN cd /tmp && \
    mkdir -p $CONDA_DIR
RUN wget --quiet https://repo.continuum.io/miniconda/Miniconda3-4.1.11-Linux-x86_64.sh 
RUN echo "874dbb0d3c7ec665adf7231bbb575ab2 *Miniconda3-4.1.11-Linux-x86_64.sh" | md5sum -c - && \
    /bin/bash Miniconda3-4.1.11-Linux-x86_64.sh -f -b -p $CONDA_DIR && \
    rm Miniconda3-4.1.11-Linux-x86_64.sh && \
    conda config --system --add channels conda-forge && \
    conda config --system --set channel_priority false && \
    conda config --system --set auto_update_conda false && \
    conda install --quiet --yes python==3.4.5 cython==0.25.1 numpy==1.8.2 scipy==0.13.3 matplotlib==1.3.1 lapack==3.6.1 mumps==5.0.2 sphinx==1.4.8 gcc toolchain tinyarray pytest pytest-runner  && \  # root env is baseline
    conda clean -tipsy
