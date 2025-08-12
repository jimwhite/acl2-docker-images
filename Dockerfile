FROM quay.io/jupyter/pyspark-notebook:latest
LABEL org.opencontainers.image.source="https://github.com/jimwhite/acl2-docker"

ARG USER=jovyan
ENV HOME=/home/${USER}

USER root

# This will have RW permission for the ACL2 directory.
RUN echo 'jovyan ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers && \
    adduser jovyan sudo && \
    groupadd acl2 && \
    usermod -aG acl2 ${USER} && \
    mkdir /opt/acl2 && \
    chown -R ${USER}:acl2 /opt/acl2
    # && chmod -R g+rx /opt/acl2

# Based on https://github.com/wshito/roswell-base

# openssl-dev is needed for Quicklisp
# perl is needed for ACL2's certification scripts
# wget is needed for downloading some files while building the docker image
# The rest are needed for Roswell

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        gcc \
        git \
        automake \
        autoconf \
        make \
        libcurl4-openssl-dev \
        ca-certificates \
        libssl-dev \
        wget \
        perl \
        zlib1g-dev \
        libzstd-dev \
        curl \
        unzip \
        rlwrap \
        retry \
        sbcl \
    && rm -rf /var/lib/apt/lists/* # remove cached apt files

RUN mkdir /root/sbcl \
    && cd /root/sbcl \
    && wget "http://prdownloads.sourceforge.net/sbcl/sbcl-2.5.3-source.tar.bz2?download" -O sbcl.tar.bz2 -q \
    && echo "8a1e76e75bb73eaec2df1ee0541aab646caa1042c71e256aaa67f7aff3ab16d5  sbcl.tar.bz2" > sbcl.tar.bz2.sha256 \
    && sha256sum -c sbcl.tar.bz2.sha256 \
    && rm sbcl.tar.bz2.sha256 \
    && tar -xjf sbcl.tar.bz2 \
    && rm sbcl.tar.bz2 \
    && cd sbcl-* \
    && sh make.sh --without-immobile-space --without-immobile-code --without-compact-instance-header --fancy --dynamic-space-size=4Gb \
    && apt-get remove -y sbcl \
    && sh install.sh \
    && cd /root \
    && rm -R /root/sbcl

ARG ACL2_COMMIT=0
ENV ACL2_SNAPSHOT_INFO="Git commit hash: ${ACL2_COMMIT}"
ARG ACL2_BUILD_OPTS=""
ARG ACL2_CERTIFY_OPTS="-j 6"
# ARG ACL2_CERTIFY_TARGETS="basic"
# The ACL2 Bridge and such for Jupyter need everything.
ARG ACL2_CERTIFY_TARGETS="all acl2s centaur/bridge"
ENV CERT_PL_RM_OUTFILES="1"

ENV ACL2_HOME=/home/acl2

# Setup ACL2 Jupyter kernel
RUN mkdir -p /opt/conda/share/jupyter/kernels/acl2
COPY kernel.json /opt/conda/share/jupyter/kernels/acl2/
RUN chown -R ${USER}:acl2 /opt/conda/share/jupyter/kernels/acl2

# Setup ACL2 Jupyter bridge scripts
COPY acl2-jupyter.sh /usr/local/bin/acl2-jupyter.sh
RUN chmod 755 /usr/local/bin/acl2-jupyter.sh

RUN wget "https://api.github.com/repos/acl2/acl2/zipball/${ACL2_COMMIT}" -O /tmp/acl2.zip -q

RUN unzip -qq /tmp/acl2.zip -d /tmp/acl2_extract \
    && mv -T /tmp/acl2_extract/$(ls /tmp/acl2_extract) /tmp/acl2 \
    && mv -T /tmp/acl2 ${ACL2_HOME} \
    && cd ${ACL2_HOME} \
    && make LISP="sbcl" $ACL2_BUILD_OPTS \
    && cd ${ACL2_HOME}/books \
    && make ACL2=${ACL2_HOME}/saved_acl2 ${ACL2_CERTIFY_OPTS} ${ACL2_CERTIFY_TARGETS} \
    && chmod go+rx /home \
    && chmod -R g+rwx ${ACL2_HOME} \
    && chmod g+s ${ACL2_HOME} \
    && chown -R ${USER}:acl2 ${ACL2_HOME} \
    && find ${ACL2_HOME} -type d -print0 | xargs -0 chmod g+s

# Don't remove the acl2 zipball.
# This guards against future inaccessibility and speeds up Docker rebuilds
# && rm /tmp/acl2.zip \
# && rmdir /tmp/acl2_extract \

# # Needed for books/oslib/tests/copy to certify
RUN touch ${ACL2_HOME}/../foo && chmod a-w ${ACL2_HOME}/../foo && chown ${USER}:acl2 ${ACL2_HOME}/../foo

RUN mkdir -p /opt/acl2/bin \
    && ln -s ${ACL2_HOME}/saved_acl2 /opt/acl2/bin/acl2 \
    && ln -s ${ACL2_HOME}/books/build/cert.pl /opt/acl2/bin/cert.pl \
    && ln -s ${ACL2_HOME}/books/build/clean.pl /opt/acl2/bin/clean.pl \
    && ln -s ${ACL2_HOME}/books/build/critpath.pl /opt/acl2/bin/critpath.pl

COPY acl2-init.lsp start-bridge.lisp ${HOME}

# Setup tutorial notebooks (if they exist)
RUN mkdir -p ${HOME}/programming-tutorial
COPY acl2-notebooks/programming-tutorial/* ${HOME}/programming-tutorial/

RUN chown -R ${USER}:users ${HOME}

USER ${USER}

ENV PATH="/opt/acl2/bin:${PATH}"
ENV ACL2_SYSTEM_BOOKS="${ACL2_HOME}/books"
ENV ACL2="/opt/acl2/bin/saved_acl2"

# Install ACL2 Jupyter kernel
RUN pip install acl2_jupyter

WORKDIR ${HOME}

# Use the ACL2 Jupyter bridge as entrypoint
ENTRYPOINT ["bash", "-c", "/usr/local/bin/acl2-jupyter.sh"]
