docker role
==============
This roles install and configure docker

Requirements
------------
### Supported Operating Systems

- RedHat-family Linux Distributions

Tags
----------
### Supported tags

- `docker_install`
  - Installs docker
- `docker_configure`
  - Configures docker
- `docker_enable`
  - Enables docker

Usage
-----
Create `docker.yml` playbook and execute it:

```---
- hosts: all
  user: "{{ ansible_ssh_user }}"

  roles:
    - docker
```
