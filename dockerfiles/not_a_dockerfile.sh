#! /bin/sh
# literally don't know how dockerfiles work
# even if i did, this new lab is so weird
#set -e
#trap 'lmao it broke' ERR

ansible-galaxy collection install community.windows
ansible-galaxy collection install ansible.windows
ansible-galaxy collection install ansible.posix
ansible-galaxy collection install netapp.ontap:21.14.1

ssh-keygen -t rsa -q -f "$HOME/.ssh/id_rsa" -N ""
sshpass -p Netapp1! ssh-copy-id 192.168.0.4
sshpass -p Netapp1! scp -o StrictHostKeyChecking=no ~/.ssh/id_rsa.pub administrator@demo@dc1.demo.netapp.com:C:\\ProgramData\\ssh\\administrators_authorized_keys
sshpass -p Netapp1! scp -o StrictHostKeyChecking=no ~/.ssh/id_rsa.pub administrator@demo@jumphost.demo.netapp.com:C:\\ProgramData\\ssh\\administrators_authorized_keys
sshpass -p Netapp1! ssh root@192.168.0.61 mkdir -p ~/.ssh
sshpass -p Netapp1! scp -o StrictHostKeyChecking=no ~/.ssh/id_rsa.pub root@centos01.demo.netapp.com:~/.ssh/authorized_keys

sshpass -p Netapp1! ssh -o StrictHostKeyChecking=no administrator@demo@dc1.demo.netapp.com "get-acl C:\\ProgramData\\ssh\\ssh_host_dsa_key | set-acl C:\\ProgramData\\ssh\\administrators_authorized_keys"
sshpass -p Netapp1! ssh -o StrictHostKeyChecking=no administrator@demo@jumphost.demo.netapp.com "get-acl C:\\ProgramData\\ssh\\ssh_host_dsa_key | set-acl C:\\ProgramData\\ssh\\administrators_authorized_keys"

echo "DC1.demo.netapp.com ansible_connection=ssh ansible_user=administrator@demo ansible_shell_type=powershell" >> /etc/ansible/hosts
echo "jumphost.demo.netapp.com ansible_connection=ssh ansible_user=administrator@demo ansible_shell_type=powershell" >> /etc/ansible/hosts
echo "centos01.demo.netapp.com ansible_connection=ssh anisble_user=root" >> /etc/ansible/hosts
echo "awx.demo.netapp.com ansible_connection=ssh ansible_user=root" >> /etc/anisble/hosts

ansible-pull -U https://github.com/nasteam/LOD-ansible.git new-playbooks/nick01.yml
