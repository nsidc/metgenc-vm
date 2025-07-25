# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'vagrant-nsidc/plugin'

Vagrant.configure(2) do |config|
  memory_gb = 16

  config.vm.provider :vsphere do |vsphere|
    vsphere.memory_mb = 1024 * memory_gb
    vsphere.cpu_count = 4
  end

  config.vm.provision :shell do |s|
    s.name = 'apt-get update'
    s.inline = 'apt-get update'
  end

  config.vm.synced_folder ".", "/vagrant", type: "rsync", rsync__exclude: ["/puppet/modules/*", "/puppet/.tmp/*"]

  config.vm.provision :shell do |s|
    s.name = 'librarian-puppet install'
    s.inline = 'cd /vagrant/puppet && librarian-puppet install --path=./modules --verbose'
  end

  config.vm.provision :puppet do |puppet|
    puppet.working_directory = '/vagrant'
    puppet.manifests_path = './puppet'
    puppet.manifest_file = 'site.pp'
    puppet.options = '--detailed-exitcodes --modulepath ./puppet/modules'
    puppet.environment = VagrantPlugins::NSIDC::Plugin.environment
    puppet.environment_path = './puppet/environments'
    puppet.hiera_config_path = './puppet/hiera.yaml'
  end
end
