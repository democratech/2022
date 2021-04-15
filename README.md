# LaPrimaire.org 2022

<!-- TOC depthFrom:2 -->

- [1. Development](#1-development)
    - [1.1. Requirements](#11-requirements)
    - [1.2. Add the local host/IP entries](#12-add-the-local-hostip-entries)
    - [1.3. Environment variables](#13-environment-variables)
    - [1.4. Provision the development VMs](#14-provision-the-development-vms)
    - [1.5. Adding/removing/upgrading 3rd party Ansible roles](#15-addingremovingupgrading-3rd-party-ansible-roles)
    - [1.6. Pre-commit hook](#16-pre-commit-hook)
- [2. Hosts](#2-hosts)
- [3. Security](#3-security)
    - [3.1. SSL](#31-ssl)
    - [3.2. Single Sign On](#32-single-sign-on)

<!-- /TOC -->

## 1. Development

### 1.1. Requirements

- Vagrant 2.2.9+
- VirtualBox 6+
- Git 2.25+

### 1.2. Add the local host/IP entries

In order to be able to use the actual hostname (instead of the IP) of each
host, the local machine configuration must be updated.
Edit your hosts file to add the following entries:

```
192.168.142.2    2022.laprimaire.org.test
192.168.142.2    org.laprimaire.org.test
192.168.142.2    analytics.infra.laprimaire.org.test
192.168.142.2    monitoring.infra.laprimaire.org.test
192.168.142.2    logs.infra.laprimaire.org.test
```

- On Windows, open Notepad as an Administrator and open/edit `C:\windows\system32\drivers\etc\hosts`.
- On Linux/macOS, edit `/etc/hosts`.

### 1.3. Environment variables

| Name | Required | Description |
|-|-|-|
| `LAPRIMAIRE_2022_SSH_KEY` | no | The full path to the SSH key for the LaPrimaire.org 2022 server. |
| `DISCOURSE_POSTGRESQL_PASSWORD` | no | The password for the PostgreSQL user used by Discourse. |
| `DISCOURSE_SMTP_HOST` | no | The SMTP host used by Discourse. |
| `DISCOURSE_SMTP_PORT` | no | The SMTP port used by Discourse. |
| `DISCOURSE_SMTP_USER` | no | The SMTP user used by Discourse. |
| `DISCOURSE_SMTP_PASSWORD` | no | The SMTP password used by Discourse. |
| `DISCOURSE_SMTP_TLS` | no | Whether Discourse must use SMTP over TLS (`yes` or `no`). |
| `DISCOURSE_REDIS_PASSWORD` | no | The Redis password used by Discourse. |
| `GHOST_DATABASE_USER` | no | The database user used by Ghost. |
| `GHOST_DATABASE_PASSWORD` | no | The database password used by Ghost. |
| `MATOMO_DATABASE_USER` | no | The Matomo database username. |
| `MATOMO_DATABASE_PASSWORD` | no | The Matomo database password. |
| `MATOMO_USER` | no | The Matomo admin username. |
| `MATOMO_PASSWORD` | no | The Matomo admin password. |
| `VOUCH_OAUTH_CLIENT_ID` | no | The (GitHub) OAuth client ID used by Vouch. |
| `VOUCH_OAUTH_CLIENT_SECRET` | no | The (GitHub) OAuth client secret used by Vouch. |
| `VOUCH_WHITELIST` | no | The (comma separated) list of whitelisted GitHub usernames. |

### 1.4. Provision the development VMs

The provisioning is done by Ansible. Since Ansible does not support Windows
and might behave differently depending on the host machine, it runs in a
separate VM.

The available VMs and their status can be listed via the following command:

```bash
vagrant status
```

The complete virtualized setup can be automagically created using the following
command:

```bash
vagrant up
```

**By default, if no machine name is specified, all machines will be created/provisioned.**
Keep in mind starting all the VMs will potentially require a lot of time
and hardware resources. Each machine can be started individually using the
`vagrant up` command. For example the following command will create and
provision only the VM for the `laprimaire_2022` host:

```bash
vagrant up laprimaire_2022 ansible
```

**Note:** the `ansible` machine is the one running Ansible on the other VMs.
Thus, it must always be created and provisioning it will provision the other
VMs.

You can ead more about the available `vagrant` commands in the official
[Vagrant CLI documentation](https://www.vagrantup.com/docs/cli):

* [Vagrant - Up](https://www.vagrantup.com/docs/cli/up)
* [Vagrant - Destroy](https://www.vagrantup.com/docs/cli/destroy)
* [Vagrant - Provision](https://www.vagrantup.com/docs/cli/provision)
* [Vagrant - Multi-machines](https://www.vagrantup.com/docs/multi-machine)

### 1.5. Adding/removing/upgrading 3rd party Ansible roles

The `provisioning/roles` folder contains both our custom roles (prefixed with
`aerys.`) and third party roles. Those third party roles are installed from
Ansible Galaxy.

The 3rd party roles are added directly to the git repository in order to make
sure we do not rely on Ansible Galaxy to provision our infrastructure.

Those 3rd party roles are listed in `provisioning/requirements.yml`. You can
edit this file to add new roles, remove the ones that are not used anymore
or upgrade the existing one. When you're done editing `requirements.yml`, the
corresponding roles have to be (re)downloaded.

Here is the full procedure:

1. Edit `provisioning/requirements.yml` to upgrade/add/remove roles.
2. Delete all the 3rd party roles:

```bash
ls -d provisioning/roles/* | grep -v 'laprimaire.' | xargs rm -rf
```

3. Download the roles listed in `provisioning/requirements.yml`:

```bash
ansible-galaxy install -r ./provisioning/requirements.yml -p ./provisioning/roles
```

4. Add the new roles (if any) to the git repository with `git add`, commit
your changes with `git commit` and then push them wight `git push`.

### 1.6. Pre-commit hook

This repository provides a pre-commit hook running `ansible-lint`, to use it:
- Install [pre-commit](https://pre-commit.com).
- Run `pre-commit install`.

## 2. Hosts

| Host | DNS | Configuration | Description |
|-|-|-|-|
| `2022` | `A` | Ubuntu 20.04, 40GB SSD, 50GB block storage, 3 X86 4GB, 300 Mbps | The blog for the 2022 edition of LaPrimaire.org. powered by Ghost. |
| `org` | `CNAME` | `2022` | The private forum used by organizers. Powered by Discourse. |
| `monitoring.infra` | `CNAME` | `2022` | Monitoring dashboards for the whole infrastructure. Powered by Grafana + Prometheus. |
| `logs.infra` | `CNAME` | `2022` | Logs for the whole infrastructure. Powered by an EFK stack. |
| `analytics.infra` | `CNAME` | `2022` | Analytics platform powered by Matomo. |

## 3. Security
### 3.1. SSL

When working with the development VMs, self-signed certificates will be automagically
created.

When deploying in production, Let'sEncrypt certificates will be automagically fetched
and renewed. In addition to the valid Let'sEncrypt certificates, all domains are managed
by Cloudflare *with end-to-end encryption* (ie Cloudflare does not see any of the actual
data).

### 3.2. Single Sign On

All the subdomains of `infra.laprimaire.org` are protected by authentication via
[vouch-proxy](https://github.com/vouch/vouch-proxy/). To access those subdomains,
the user must:

- Be authenticated on GitHub.
- Be a whitelisted user (cf the `vouch_whitelist` variable in `host_vars/laprimaire_2022/main.yml`).

**Note:** by default, this authentication mechanism is disabled in the local VM
environment. It can be enabled by setting the `vouch_enabled` Ansible variable:

```bash
ANSIBLE_EXTRA_ARGS='-e vouch_enabled=true' vagrant provision
```

For the SSO to work, the following environment variables *must* also be set:

- `VOUCH_OAUTH_CLIENT_ID`
- `VOUCH_OAUTH_CLIENT_SECRET`
- `VOUCH_WHITELIST`
