#!/bin/bash
set -x

dir="$(dirname $(readlink -f $0))"
cd $dir

# git pull && git submodule update --init
#if [ ! -f Gemfile.lock ]; then
#first run
  #apt-get update
  #apt-get install -y ruby ruby-dev make git
  #gem install bundler
  #bundle install --path=setup/bundle --binstubs=setup/bundlebin
#fi
rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm
#yum localinstall /var/tmp/ruby-1.9.3p545-1.el6.x86_64.rpm -y
#yum install puppet -y
gem install r10k

# get environment from current git branch
environment=$(git symbolic-ref --short HEAD)
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
