#!/bin/bash

sudo apt update

export DEBIAN_FRONTEND=noninteractive

echo -e " 
slapd slapd/internal/generated_adminpw password abcd123
slapd slapd/no_configuration boolean false
slapd slapd/invalid_config boolean true
slapd slapd/domain string wisc.cloudlab.us
slapd slapd/organization string clemson.cloudlab.us
slapd slapd/internal/adminpw password pkhadse
slapd slapd/backend select MDB
slapd slapd/purge_database boolean true
slapd slapd/dump_databse_destdir string /var/backups/slapd-VERSION
slapd slapd/dump_databse select when needed
slapd slapd/move_old_database boolean true
slapd slapd/password2 password abcd123
slapd slapd/password1 password abcd123
slapd slapd/password_mismatch note
slapd slapd/policy_schema_needs_update select abort installation
slapd slapd/unsafe_selfwrite_acl note
slapd slapd/upgrade_slapcat_failure error
slapd slapd/allow_ldap_v2 boolean false
" | sudo debconf-set-selections


sudo apt-get install -y slapd ldap-utils
#sudo dpkg-reconfigure slapd
sudo ufw allow ldap
