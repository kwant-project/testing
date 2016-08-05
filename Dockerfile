# Docker image for building and testing tkwant

FROM debian:stable
MAINTAINER Kwant developers <authors@kwant-project.org>


RUN echo "deb-src http://httpredir.debian.org/debian/ jessie main"\
          >> /etc/apt/sources.list && \
    apt-get update && apt-get install -y --no-install-recommends\
        # all the hard non-Python dependencies
        git g++ make patch gfortran libblas-dev liblapack-dev\
        libmumps-scotch-dev pkg-config libfreetype6-dev\
        # all the hard Python dependencies -- numpy needs to be installed
        # for building the scipy wheels
        python-all-dev python-setuptools python-pip python-tk python-wheel python-numpy\
        python3-all-dev python3-setuptools python3-pip python3-tk python3-wheel python3-numpy\
        # Additional tools for running CI
        file rsync openssh-client\
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

### install testing dependencies
# python 3
RUN pip3 install --upgrade\
    pip pytest pytest-cov pytest-flakes pytest-pep8 sphinx numpydoc\
    # nose can disappear once we use pytest
    nose nose-cov
# python 2
RUN pip2 install --upgrade\
    pip pytest pytest-cov pytest-flakes pytest-pep8 sphinx numpydoc\
    # nose can disappear once we use pytest
    nose nose-cov

### make wheels of all relevant dependency versions
#
# numpy 1.6.2 and scipy 0.9.0 aren't here due to a bug that prevents using them
# with recent distutils.  Further, not all scipy versions are used because
# there are too many of them altogether.
COPY pylibs /pylibs
RUN /pylibs/make_wheels.sh

### install dependencies
# TODO: change this when we want to switch to virtual envs for different
#       dependency combinations. For now we just get the most recent versions
RUN pip2 install --find-links=/pylibs $(/pylibs/get_recent_deps.sh) &&\
    pip3 install --find-links=/pylibs $(/pylibs/get_recent_deps.sh) &&\
    pip2 install git+https://gitlab.kwant-project.org/kwant/tinyarray.git@master &&\
    pip3 install git+https://gitlab.kwant-project.org/kwant/tinyarray.git@master

RUN ln -s /usr/local/bin/nosetests-3.4 /usr/local/bin/nosetests3
