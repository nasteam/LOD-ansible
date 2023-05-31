#! /bin/bash
dnf install libreswan
ls -lah /etc/ipsec.d
systemctl enable ipsec
systemctl start ipsec
