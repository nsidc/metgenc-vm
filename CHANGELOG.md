## Next

- Issue-365: Ensure the latest version of `pip` is used in the VM's `python`
  environment. These changes are in response to the eMudhra certificate
  compromise.

## v1.1.0 - 2026-10-15

- PSS-729: Mount `/disks/sftponly` as part of VM build.
- Add configuration for `integration` VM build for testing purposes.

## v1.0.0 - 2026-07-01

- PSS-700: Use secure templates for VM build; update version of AWS CLI; remove OBE `ecs` mount.

## v0.5.0 - 2025-09-08

- Issue-284: Install `postgresql` command-line tools via
  `puppetlabs-postgresql`.

## v0.4.0 - 2025-09-05

- Issue-276: Add logrotate configuration.

## v0.3.0 - 2025-08-27

- Issue-273: Update templates for AWS config and credentials files to include
    profiles for both UAT and PROD.
- Issue-270: Mount `/share/apps` and `/share/logs/metgenc` with write permission; use default
  or `ro` for other mounted volumes.

## v0.2.0 - 2025-08-21

## v0.1.0 - 2025-08-21

- Issue-234: Add various data mounts requested by Ops.

## v0.0.0 - 2025-08-07

- Initial CHANGELOG.md
