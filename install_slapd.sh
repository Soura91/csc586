#!/bin/bash 
export DEBIAN_FRONTEND='non-interactive'

echo -e” slapd   slapd/internal/generated_adminpw        password test
slapd   slapd/internal/adminpw  password test
slapd   slapd/password2 password test
slapd   slapd/password1 password test
# Potentially unsafe slapd access control configuration
slapd   slapd/unsafe_selfwrite_acl      note
slapd   slapd/move_old_database boolean true
slapd   slapd/no_configuration  boolean false
slapd   slapd/invalid_config    boolean true
slapd   slapd/ppolicy_schema_needs_update       select  abort installation
# Do you want the database to be removed when slapd is purged?
slapd   slapd/purge_database    boolean false
slapd   slapd/upgrade_slapcat_failure   error
slapd   slapd/backend   select  MDB
slapd   slapd/dump_database_destdir     string  /var/backups/slapd-VERSION
slapd   slapd/domain    string  clemson.cloudlab.us
slapd   slapd/dump_database     select  when needed
slapd   shared/organization     string  clemson.cloudlab.us
slapd   slapd/password_mismatch note



# Do you want the database to be removed when slapd is purged?










# Grab slapd and ldap-utils (pre-seeded)
apt-get install -y slapd ldap-utils phpldapadmin

# Must reconfigure slapd for it to work properly 
sudo dpkg-reconfigure slapd 
