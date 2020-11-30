#------------------------
# From linux base image
#   Update system
#   Install git
FROM ubuntu:18.04 as step1
RUN apt-get update -y \
  && apt-get install --yes git

#--------------------------
# Install compiler and perl
#   Clean up temp files
FROM step1 as step2-a
RUN apt-get install --yes \
  build-essential \
  gcc-multilib \
  apt-utils \
  perl \
  expat \
  libexpat-dev \
  locales \
  cpanminus \
  && apt-get clean && rm -rf /tmp/* /var/tmp/*

#--------------------------------------------
# Get files directly from GitHub repository
#   so as to prevent LF errors due to Windows
#   For Linux: COPY . /usr/ledger2beancount
FROM step1 as step2-b
RUN git clone https://github.com/beancount/ledger2beancount.git /usr/ledger2beancount

#--------------------------
# Merge step2-a and step2-b
FROM step2-a as final
COPY --from=step2-b /usr/ledger2beancount /usr/ledger2beancount

#-------------------------
# Install app dependencies
WORKDIR /usr/ledger2beancount
RUN cpanm --installdeps .

#--------------------------
# Set environment variables
#   Fix perl warnings
ENV PATH="/usr/bin/perl:$PATH"
RUN locale-gen "en_US.UTF-8"
RUN update-locale "LANG=en_US.UTF-8"
# RUN locale-gen --purge "en_US.UTF-8"
# RUN dpkg-reconfigure --frontend noninteractive locales

#-------------------------------------
# Set default script and arguments
#   This can be overridden at runtime
ENTRYPOINT [ "bin/ledger2beancount" ]
