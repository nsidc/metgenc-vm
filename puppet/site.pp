lookup('classes', {merge => unique}).include

$vault_host = 'vault.apps.int.nsidc.org'

$project = 'metgenc'
$package = 'nsidc-metgenc'
$version = '1.6.1'

# Location for running metgenc
file {"/home/vagrant/${project}":
  ensure => 'directory',
  owner  => 'vagrant',
  group  => 'vagrant',
  mode   => '0644',
}

# Contains environment variable setup and activation of conda environment for
# non-login shells (e.g., ops jobs)
file {"${project}-init.sh":
  ensure  => present,
  content => vault_template("/vagrant/puppet/files/${project}-init.erb"),
  path    => "/etc/profile.d/${project}-init.sh",
}

file {'/home/vagrant/.aws':
  ensure => 'directory',
  owner  => 'vagrant',
  group  => 'vagrant',
  mode   => '0600',
}

# Populate aws credentials with environment variables set in aws_envvars.sh
file {'/home/vagrant/.aws/credentials':
  ensure  => file,
  owner   => 'vagrant',
  group   => 'vagrant',
  mode    => '0600',
  content => vault_template('/vagrant/puppet/files/aws-credentials.erb'),
  require => File['/home/vagrant/.aws'],
}
file {'/home/vagrant/.aws/config':
  ensure  => file,
  owner   => 'vagrant',
  group   => 'vagrant',
  mode    => '0600',
  content => vault_template('/vagrant/puppet/files/aws-config.erb'),
  require => File['/home/vagrant/.aws'],
}
file {'.conda dir':
  ensure  => directory,
  path    => '/home/vagrant/.conda',
  owner   => 'vagrant',
  group   => 'vagrant'
}

file {"/home/vagrant/${project}/data":
  ensure => directory,
  owner => 'vagrant',
  group => 'vagrant',
  require => [File["/home/vagrant/${project}"]],
}
file {"/home/vagrant/${project}/init":
  ensure => directory,
  owner => 'vagrant',
  group => 'vagrant',
  require => [File["/home/vagrant/${project}"]],
}
file {"/home/vagrant/${project}/output":
  ensure => directory,
  owner => 'vagrant',
  group => 'vagrant',
  require => [File["/home/vagrant/${project}"]],
}
file {"/home/vagrant/${project}/premet":
  ensure => directory,
  owner => 'vagrant',
  group => 'vagrant',
  require => [File["/home/vagrant/${project}"]],
}
file {"/home/vagrant/${project}/spatial":
  ensure => directory,
  owner => 'vagrant',
  group => 'vagrant',
  require => [File["/home/vagrant/${project}"]],
}

# Log handling
$environment_dir = $environment ? {
    'blue'  => 'production',
    default => $environment
}

$log_source = '/share/logs/metgenc'
$log_archive = "${log_source}/archive"
$log_archive_environment = "${log_archive}/${environment_dir}"

file { "$log_archive_environment":
  ensure  => directory,
  owner  => 'vagrant',
  group  => 'vagrant',
  mode   => '0664',
  require => [Nsidc_nfs::Sharemount[$log_source]]
}  ->

file { '/etc/logrotate.d/metgenc':
   ensure  => file,
   content => template('/vagrant/puppet/files/logrotate_metgenc.erb'),
   require => [Nsidc_nfs::Sharemount[$log_source], File[$log_archive_environment]]
}

exec {'conda-init':
  command => 'conda init bash',
  path    => '/opt/miniconda/bin/:/bin/',
  user    => 'vagrant',
  group   => 'vagrant',
  require => [File['.conda dir'],
              Nsidc_miniconda::Install['/opt/miniconda']],
}

exec { 'install-python-3.12':
  command => 'conda install python=3.12',
  path    => '/opt/miniconda/bin/:/bin/',
  require => [File["${project}-init.sh"],
              File["/home/vagrant/${project}"],
              Exec['conda-init']],
}

exec { 'install-venv':
  command  => "python -m venv /home/vagrant/${project}/.venv",
  path     => '/opt/miniconda/bin/:/bin/',
  provider => 'shell',
  user     => 'vagrant',
  group    => 'vagrant',
  # timeout     => 1800,
  require => Exec['install-python-3.12']
}

exec { 'install-metgenc':
  command => ". activate && pip install ${package}",
  path    => "/home/vagrant/${project}/.venv/bin/:/bin/",
  provider => 'shell',
  user     => 'vagrant',
  group    => 'vagrant',
  timeout     => 1800,
  require => Exec['install-venv']
}

exec { 'upgrade-metgenc':
  command => ". activate && pip install --upgrade ${package}",
  path    => "/home/vagrant/${project}/.venv/bin/:/bin/",
  provider => 'shell',
  user     => 'vagrant',
  group    => 'vagrant',
  timeout     => 1800,
  require => Exec['install-metgenc']
}

package { 'awscli':
  ensure => 'installed',
}

package { 'jq':
  ensure => 'installed',
}
