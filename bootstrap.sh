#!/usr/bin/env bash

set -e

as_vagrant='sudo -u vagrant -H bash -l -c'
home='/home/vagrant'
touch $home/.bash_profile


# Use all available CPU cores for compiling
if [[ $(nproc) -gt 1 ]] && ! grep -q "make -j" $home/.bash_profile; then
  echo 'export MAKE="make -j$(nproc)"' >> $home/.bash_profile
  source $home/.bash_profile
fi

apt-get -y update
apt-get install -y \
  build-essential \
  curl \
  default-jdk \
  git-core \
  mingw-w64 \
  libcurl4-openssl-dev \
  libffi-dev \
  libreadline-dev \
  libsqlite3-dev \
  libssl-dev \
  libxml2-dev \
  libxslt1-dev \
  libyaml-dev \
  python-software-properties \
  sqlite3 \
  tree \
  zlib1g-dev


### Installing Chruby
### https://github.com/postmodern/chruby
pushd /usr/local/src
curl -L -O https://raw.github.com/postmodern/postmodern.github.io/master/postmodern.asc
gpg --import postmodern.asc
curl -L https://github.com/postmodern/chruby/archive/v0.3.9.tar.gz > chruby-0.3.9.tar.gz
curl -L -O https://raw.github.com/postmodern/chruby/master/pkg/chruby-0.3.9.tar.gz.asc
gpg --verify chruby-0.3.9.tar.gz.asc chruby-0.3.9.tar.gz
tar -xzvf chruby-0.3.9.tar.gz
pushd chruby-0.3.9
./scripts/setup.sh
popd
popd

### Installing ruby-install
### https://github.com/postmodern/ruby-install
pushd /usr/local/src
curl -L https://github.com/postmodern/ruby-install/archive/v0.5.0.tar.gz > ruby-install-0.5.0.tar.gz
curl -L -O https://raw.github.com/postmodern/ruby-install/master/pkg/ruby-install-0.5.0.tar.gz.asc
gpg --verify ruby-install-0.5.0.tar.gz.asc ruby-install-0.5.0.tar.gz
tar -xzvf ruby-install-0.5.0.tar.gz
pushd ruby-install-0.5.0
make install
popd
popd

### Install the rubies
ruby-install ruby 2.2.3
ruby-install ruby 2.1.7
ruby-install jruby 9.0.1.0
