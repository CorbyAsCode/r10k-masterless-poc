#!/bin/bash
set -x
set -e

yum install centos-release-scl -y
yum install ruby200-scldevel ruby200-ruby -y
source /opt/rh/ruby200/enable
gem install bundler
bundle install --path=setup/bundle --binstubs=setup/bundlebin

# Alternative method for installing gems
#gem install puppet -v '3.8.2' --no-ri --no-rdoc
#gem install puppet-lint --no-ri --no-rdoc
#gem install puppetlabs_spec_helper --no-ri --no-rdoc
#gem install rake --no-ri --no-rdoc
#gem install librarian-puppet --no-ri --no-rdoc
#gem install r10k --no-ri --no-rdoc

# Export the path to bundler
export PATH=/opt/rh/ruby200/root/usr/local/bin:$PATH

# get environment from current git branch
environment=$(git symbolic-ref HEAD | awk -F/ '{print $3}')

# ssh wrapper to use custom sshkey for git
export GIT_SSH="setup/git_ssh"

#fix permissions of ssh private key
chmod 600 setup/.ssh/puppet_rsa

# deploy Puppetmodules and hieradata
# deploys from remote git repository!
setup/bundlebin/r10k deploy environment $environment
# Use this method for r10k if you used the alternative method
# for installing the gems
#r10k deploy environment $environment

# Run Puppet
setup/bundlebin/puppet apply --modulepath=/etc/puppet/environments/$environment/modules --hiera_config=hiera.yaml --environment $environment site.pp $@
# Use this method for r10k if you used the alternative method
# for installing the gems
#puppet apply --modulepath=/etc/puppet/environments/$environment/modules --hiera_config=hiera.yaml --environment $environment site.pp $@
