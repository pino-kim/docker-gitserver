#!/bin/bash
# reference: /usr/share/fedora-dockerfiles/ssh/entrypoint.sh

__create_rundir() {
        mkdir -p /var/run/sshd
}

__create_hostkeys() {
    ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ''
    ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N ''
    ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ''
}

# Call all functions
__create_rundir
__create_hostkeys

exec "$@"

