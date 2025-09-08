<p align="center">
  <img alt="NSIDC logo" src="https://nsidc.org/themes/custom/nsidc/logo.svg" width="150" />
</p>


# MetGenC VM

MetGenC VM provides configuration for a virtual machine used to run
[`metgenc`](https://github.com/nsidc/granule-metgen).


## Level of Support

This repository is not (yet) actively supported by NSIDC but we welcome issue submissions and
pull requests in order to foster community contribution.

See the [LICENSE](LICENSE.md) for details on permissions and warranties. Please contact
nsidc@nsidc.org for more information.


## Requirements

* Vagrant, [`vagrant-vsphere`](https://github.com/nsidc/vagrant-vsphere), the `vagrant-nsidc`
  plugin, and access to the NSIDC VPN or internal network.
* Ruby and bundler, for version bumping. Ruby tools are used here based on the
  fact that `vagrant-nsidc` is Ruby-based. Whether other solutions are better is
  an exercise left to the reader!

## Building a VM

* Ensure you have installed `vagrant`, `vagrant-vsphere`, and `vagrant-nsidc`.
* From the root of this repository's workspace, do:

```
vagrant nsidc up --env [dev|qa|staging|blue]
```

Tag the branch so there's a record of the configuration used to build the
specified environment:

```
git tag -f <env> # environment is one of dev, qa, staging, blue
git push --follow-tags
```

If the environment in question is `blue`, submit a Production Change Tracker
(PCT) request for a blue-green swap to deploy the new production VM.


## Releasing a new version

* Ensure you have
    [Ruby](https://www.ruby-lang.org/en/documentation/installation/) installed.
    [rbenv](https://github.com/rbenv/rbenv#readme) is recommended to manage your
    Ruby versions.
* Install `bundler`: `gem install bundler`
* Install remaining gem(s) (only `bump` currently): `bundle install`
* `bump --help` will show all commands.
* Add a description of the changes to the `Next` section in the [CHANGELOG.md](CHANGELOG.md).
* Run `bump <level> --changelog --tag --tag-prefix ""` where `<level>` is `pre`, `patch`, `minor`, or `major`
* Do a `git push --follow-tags` to update the remote repository.

## Logs

`/share/logs/metgenc` is NFS-mounted on the `metgenc` VM. The `logrotate`
utility is configured to rotate any files named `*.log` in that location
to an archive location at `share/logs/metgenc/archive`. 

The file `puppet/files/logrotate_metgenc.erb` stores the logrotate
configuration, which is rendered to `/etc/logrotate.d/metgenc` when the VM is
provisioned.

### Checking `logrotate` configuration and recent execution

```
sudo grep metgenc /var/lib/logrotate/status # See recent logrotate activity specific to metgenc
sudo logrotate -d /etc/logrotate.d/metgenc  # Perform a dry run, with verbose output
```

### Manually running `logrotate`

```
sudo logrotate -fv /etc/logrotate.d/metgenc # -v flag increases output verbosity
```

## Credit

This content was developed by the National Snow and Ice Data Center with funding from
multiple sources.
