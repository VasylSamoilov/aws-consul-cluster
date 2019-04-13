consul role
==============
This roles pull consul docker image

Requirements
------------
### Supported Operating Systems

- RedHat-family Linux Distributions
- Debian-family Linux Distributions

Usage
-----
Create `consul.yml` playbook and execute it:

```---
- hosts: all
  user: "{{ ansible_ssh_user }}"

  roles:
    - consul
```
