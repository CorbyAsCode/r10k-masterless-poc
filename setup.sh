#!/bin/bash
set -x

#dir="$(dirname $(readlink -f $0))"
#cd $dir

# git pull && git submodule update --init
#if [ ! -f Gemfile.lock ]; then
#first run
  #apt-get update
  #apt-get install -y ruby ruby-dev make git
  #gem install bundler
  #bundle install --path=setup/bundle --binstubs=setup/bundlebin
#fi
yum install centos-release-scl -y
yum install ruby200-scldevel ruby200-ruby -y
source /opt/rh/ruby200/enable
gem install puppet -v '3.8.2' --no-ri --no-rdoc
gem install puppet-lint --no-ri --no-rdoc
gem install puppetlabs_spec_helper --no-ri --no-rdoc
gem install rake --no-ri --no-rdoc
gem install librarian-puppet --no-ri --no-rdoc
gem install r10k --no-ri --no-rdoc

export PATH=/opt/rh/ruby200/root/usr/local/bin:$PATH

# get environment from current git branch
environment=$(git symbolic-ref HEAD | awk -F/ '{print $3}')
#environment=$1

# ssh wrapper to use custom sshkey for git
export GIT_SSH="${dir}/setup/git_ssh"

#fix permissions of ssh private key
chmod 600 $dir/setup/.ssh/puppet_rsa

# deploy Puppetmodules and hieradata
# deploys from remote git repository!
#setup/bundlebin/r10k deploy environment $environment
r10k deploy environment $environment

# Run Puppet
#setup/bundlebin/puppet apply --modulepath=/etc/puppet/environments/$environment/modules --hiera_config=hiera.yaml --environment $environment site.pp $@
puppet apply --modulepath=/etc/puppet/environments/$environment/modules --hiera_config=hiera.yaml --environment $environment site.pp $@

