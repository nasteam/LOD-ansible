#! /bin/sh
# literally don't know how dockerfiles work
# even if i did, this new lab is so weird
#set -e
#trap 'lmao it broke' ERR

# ensure required collections are installed. ansible.windows and ansible.posix are redundant, but purple text isn't a bad thing
ansible-galaxy collection install community.windows
ansible-galaxy collection install ansible.windows
ansible-galaxy collection install ansible.posix
ansible-galaxy collection install netapp.ontap:21.14.1

# prep ssh keys
ssh-keygen -t rsa -q -f "$HOME/.ssh/id_rsa" -N ""
sshpass -p Netapp1! ssh-copy-id 192.168.0.4

# copy to Windows Hosts
sshpass -p Netapp1! scp -o StrictHostKeyChecking=no ~/.ssh/id_rsa.pub administrator@demo@dc1.demo.netapp.com:C:\\ProgramData\\ssh\\administrators_authorized_keys
sshpass -p Netapp1! scp -o StrictHostKeyChecking=no ~/.ssh/id_rsa.pub administrator@demo@jumphost.demo.netapp.com:C:\\ProgramData\\ssh\\administrators_authorized_keys
sshpass -p Netapp1! ssh -o StrictHostKeyChecking=no administrator@demo@dc1.demo.netapp.com "get-acl C:\\ProgramData\\ssh\\ssh_host_dsa_key | set-acl C:\\ProgramData\\ssh\\administrators_authorized_keys"
sshpass -p Netapp1! ssh -o StrictHostKeyChecking=no administrator@demo@jumphost.demo.netapp.com "get-acl C:\\ProgramData\\ssh\\ssh_host_dsa_key | set-acl C:\\ProgramData\\ssh\\administrators_authorized_keys"

# add resource record for centos01 because ansible has hostname dependencies lmao
sshpass -p Netapp1! ssh -o StrictHostKeyChecking=no administrator@demo@dc1.demo.netapp.com "Add-DnsServerResourceRecordA -Name "centos01" -IPv4Address "192.168.0.61" -ZoneName "demo.netapp.com" -AllowUpdateAny -TimeToLive "24:00:00""

# setup Linux client
sshpass -p Netapp1! ssh StrictHostKeyChecking=no root@centos01.demo.netapp.com mkdir -p ~/.ssh
sshpass -p Netapp1! scp -o StrictHostKeyChecking=no ~/.ssh/id_rsa.pub root@centos01.demo.netapp.com:~/.ssh/authorized_keys

# add all your ssh dudes to the ansible hosts file
echo "DC1.demo.netapp.com ansible_connection=ssh ansible_user=administrator@demo ansible_shell_type=powershell" >> /etc/ansible/hosts
echo "jumphost.demo.netapp.com ansible_connection=ssh ansible_user=administrator@demo ansible_shell_type=powershell" >> /etc/ansible/hosts
echo "centos01.demo.netapp.com ansible_connection=ssh anisble_user=root" >> /etc/ansible/hosts
echo "awx.demo.netapp.com ansible_connection=ssh ansible_user=root" >> /etc/anisble/hosts

# try to dl a playbook
# TO-DO: Fix this. It keeps saying no hosts found for centos01, I don't know what to do
# ansible-pull -U https://github.com/nasteam/LOD-ansible.git new-playbooks/nick01.yml

# use curl instead
curl -L -o playbook.yml https://github.com/nasteam/LOD-ansible/raw/main/new-playbooks/nick01.yml

# play the playbook for you lmao
ansible-playbook playbook.yml
