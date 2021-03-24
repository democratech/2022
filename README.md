# LaPrimaire.org 2022

<!-- TOC depthFrom:2 -->

- [1. Development](#1-development)
    - [1.1. Requirements](#11-requirements)
    - [1.2. Add the local host/IP entries](#12-add-the-local-hostip-entries)
    - [1.3. Environment variables](#13-environment-variables)
    - [1.4. Provision the development VMs](#14-provision-the-development-vms)
    - [1.5. Adding/removing/upgrading 3rd party Ansible roles](#15-addingremovingupgrading-3rd-party-ansible-roles)
- [2. SSL](#2-ssl)

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
192.168.142.2    analytics.laprimaire.org.test
```

- On Windows, open Notepad as an Administrator and open/edit `C:\windows\system32\drivers\etc\hosts`.
- On Linux/macOS, edit `/etc/hosts`.

### 1.3. Environment variables

| Name | Required | Description |
|-|-|-|
| `LAPRIMAIRE_2022_HOST` | no | The FQDN/IP of the LaPrimaire.org 2022 server. |
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

## 2. SSL

When working with the development VMs, self-signed certificates will be automagically
created.

When deploying in production, Let'sEncrypt certificates will be automagically fetched
and renewed. In addition to the valid Let'sEncrypt certificates, the `2022.laprimaire.org`
and `org.laprimaire.org` domains are managed by Cloudflare *with end-to-end
encryption* (ie Cloudflare does not see any of the actual data).
