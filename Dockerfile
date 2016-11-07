# Docker image for building and testing tkwant
FROM ubuntu:14.04
MAINTAINER Kwant developers <authors@kwant-project.org>

RUN echo "deb-src http://httpredir.debian.org/debian/ jessie main" \
          >> /etc/apt/sources.list && \
    apt-get update && apt-get install -y --no-install-recommends \
        # all the hard non-Python dependencies
        git g++ make patch gfortran libblas-dev liblapack-dev \
        libmumps-scotch-dev pkg-config libfreetype6-dev \
        # all the hard Python dependencies
        python-all-dev python-setuptools python-pip python-tk python-wheel \
        python-numpy python-scipy python-matplotlib \
        python3-all-dev python3-setuptools python3-pip python3-tk python3-wheel \
        python3-numpy python3-scipy python3-matplotlib \
        # Additional tools for running CI
        file rsync openssh-client \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

### install build and testing dependencies
RUN for PIP in pip2 pip3 \
    ; do $PIP install \
      cython==0.22 \
      pytest>=2.6.3\
      pytest-runner>=2.7 \
      pytest-cov \
      pytest-flakes \
      pytest-pep8 \
      nose>=1.0\
      nose-cov \
      sphinx \
      numpydoc \
      # change this once tinyarray 1.2.0 is on PyPi / we have packages for it
      # tinyarray>=1.2.0a0 \
      git+https://gitlab.kwant-project.org/kwant/tinyarray.git@v1.2.0a1 \
    ; done
