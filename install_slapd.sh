#!/bin/bash 
#Install openLDAP on server
export DEBIAN_FRONTEND=non-interactive

echo -e "slapd   slapd/root_password password password abcd123" |debconf-set-selections
echo -e "slapd   slapd/root_password_again password password abcd123" |debconf-set-selections
echo -e "slapd   slapd/internal/generated_adminpw        password abcd123" |debconf-set-selections
echo -e "slapd   slapd/internal/adminpw  password abcd123" |debconf-set-selections
echo -e "slapd   slapd/password1 password abcd123" |debconf-set-selections
echo -e "slapd   slapd/password2 password abcd123" |debconf-set-selections
echo -e "slapd   slapd/invalid_config    boolean true" |debconf-set-selections
# Do you want the database to be removed when slapd is purged?
echo -e "slapd   slapd/purge_database    boolean false" |debconf-set-selections
echo -e "slapd   slapd/dump_database     select  when needed" |debconf-set-selections
echo -e "slapd   slapd/dump_database_destdir     string  /var/backups/slapd-VERSION" |debconf-set-selections
echo -e "slapd   slapd/move_old_database boolean true" |debconf-set-selections
echo -e "slapd   slapd/no_configuration  boolean false" |debconf-set-selections
echo -e "slapd   slapd/backend   select  MDB" |debconf-set-selections
echo -e "slapd   slapd/password_mismatch note" |debconf-set-selections
echo -e "slapd   slapd/domain    string  clemson.cloudlab.us" |debconf-set-selections
echo -e "slapd   slapd/upgrade_slapcat_failure   error" |debconf-set-selections
echo -e "slapd   slapd/ppolicy_schema_needs_update       select  abort installation" |debconf-set-selections
# Potentially unsafe slapd access control configuration
echo -e "slapd   slapd/unsafe_selfwrite_acl      note" |debconf-set-selections
echo -e "slapd   shared/organization     string  clemson.cloudlab.us" |debconf-set-selections

sudo apt-get update
sudo apt-get install -y slapd ldap-utils
sudo dpkg-reconfigure slapd
sudo ufw allow ldap 
