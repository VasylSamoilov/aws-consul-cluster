## Packer

### Prerequisites
* Install packer: `https://www.packer.io/intro/getting-started/install.html`
* Configure AWS credentials

### Build AMI
`packer build consul.json`

Note: Packer uses `ansible-local` provisioner because `ansible` provisioner has issues with RedHat family distribution. See https://www.packer.io/docs/provisioners/ansible.html#redhat-centos
