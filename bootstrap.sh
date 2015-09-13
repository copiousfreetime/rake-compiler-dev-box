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
  zlib1g-dev

git clone git://github.com/sstephenson/rbenv.git /opt/rbenv
git clone git://github.com/sstephenson/ruby-build.git /opt/rbenv/plugins/ruby-build
cat <<EOF > /etc/profile.d/rbenv.sh
export RBENV_ROOT=/opt/rbenv
export PATH="\$RBENV_ROOT/bin:\$RBENV_ROOT/plugins/ruby-build/bin:\$PATH"
eval "\$(rbenv init -)"
EOF
echo "gem: --no-ri --no-rdoc" >> /etc/gemrc

source /etc/profile.d/rbenv.sh

rbenv install -v 2.2.3
rbenv install -v jruby-9.0.1.0
rbenv global 2.2.3
