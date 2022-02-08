FROM ubuntu:bionic
ARG PACKAGES=packages.txt
ARG USER=R
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC
ENV HOME /home/R
SHELL ["/bin/bash", "-c"]
RUN apt-get update -y
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:c2d4u.team/c2d4u4.0+
RUN add-apt-repository ppa:ubuntu-toolchain-r/test
RUN apt-get update -y
RUN apt-get install -y build-essential \ 
    g++ gpg \ 
    wget \
    libxml2-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    texlive \
    gfortran \
    git \
    subversion \
    ccache \
    texlive-fonts-extra \
    texlive-latex-extra \
    libreadline-dev \
    libbz2-dev \
    libpcre2-dev \
    tcl-dev \
    tk-dev \
    rsync \
    xinetd \
    ssh \
    gcc-9 \
    g++-9 \
    python3 \ 
    python3-{venv,dbus,gi,apt,pip}
RUN apt-get install -y libgit2-dev
RUN cp /etc/apt/sources.list /etc/apt/sources.list~ && \
    sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list
RUN apt-get update
RUN apt-get build-dep -y r-base
RUN wget -O pandoc-2.17.deb https://github.com/jgm/pandoc/releases/download/2.17.0.1/pandoc-2.17.0.1-1-amd64.deb
RUN dpkg -i pandoc-2.17.deb
RUN useradd --home-dir ${HOME} --expiredate '' --create-home R
USER R
RUN mkdir -p ${HOME}/packages/src
WORKDIR ${HOME}/packages/src
COPY R_INSTALL.sh R_INSTALL.sh
USER root
RUN chmod +x R_INSTALL.sh && chown R:R R_INSTALL.sh
USER R
RUN ./R_INSTALL.sh ${HOME}/bin/packages/R
RUN wget https://cran.r-project.org/src/contrib/bspm_0.3.9.tar.gz
RUN tar xvf bspm_0.3.9.tar.gz
WORKDIR ${HOME}/bin
RUN ln -fs ${HOME}/bin/packages/R/bin/* .
WORKDIR ${HOME}/packages/src
RUN ~/bin/R install bspm_0.3.9.tar.gz 
WORKDIR ${HOME}
RUN rm -rf ${HOME}/packages/src
RUN python3 -m venv ./bin/python
RUN source ${HOME}/bin/python/bin/activate
COPY --chown=R print_home.r print_home.r
COPY --chown=R ${PACKAGES} packages.txt
COPY --chown=R package_install_gen.py package_install_gen
RUN chmod +x package_install_gen
RUN ./package_install_gen
USER R
RUN echo "bspm::enable()" > $(~/bin/Rscript print_home.r)/etc/RProfile.site
RUN echo 'local({\
  r <- getOption("repos")\
  r["CRAN"] <- "http://cran.us.r-project.org"\
  options(repos = r)\
})' >> $(~/bin/Rscript print_home.r)/etc/RProfile.site
RUN export scripts=$(ls install*) && ~/bin/Rscript ${scripts}
COPY vscode.r vscode.r
RUN ~/bin/Rscript "vscode.r"
RUN pip3 install -U wheel
RUN pip3 install -U radian
RUN echo "alias r=radian" >> ~/.bashrc
RUN mkdir -p ~/src
WORKDIR $HOME
#RUN which python
# add new user

