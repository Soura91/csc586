#!/bin/bash

sudo apt update

export DEBIAN_FRONTEND=noninteractive

echo -e " 
slapd slapd/internal/generated_adminpw password abcd123
slapd slapd/no_configuration boolean false
slapd slapd/invalid_config boolean true
slapd slapd/domain string wisc.cloudlab.us
slapd slapd/organization string clemson.cloudlab.us
slapd slapd/internal/adminpw password abcd123
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
ldapadd -x -D cn=admin,dc=clemson,dc=cloudlab,dc=us -w abcd123 -f basedn.ldif

#echo   -n  PASS=$(slappasswd -s rammy) | awk '{print PASS}'
PASS=$(slappasswd -s rammy)
cat <<EOF >/local/repository/users.ldif
dn: uid=student,ou=People,dc=clemson,dc=cloudlab,dc=us
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: shadowAccount
uid: student
sn: Ram
givenName: Golden
cn: student
displayName: student
uidNumber: 10000
gidNumber: 5000
userPassword: $PASS
gecos: Golden Ram
loginShell: /bin/dash
homeDirectory: /home/student
EOF


ldapadd -x -D cn=admin,dc=clemson,dc=cloudlab,dc=us -w abcd123 -f users.ldif

echo -e " 
ldap-auth-config        ldap-auth-config/rootbindpw     password abcd123
ldap-auth-config        ldap-auth-config/bindpw password abcd123
ldap-auth-config        ldap-auth-config/binddn string  cn=proxyuser,dc=example,dc=net
ldap-auth-config        ldap-auth-config/override       boolean true
ldap-auth-config        ldap-auth-config/pam_password   select  md5
ldap-auth-config        ldap-auth-config/dblogin        boolean false
slapd   slapd/allow_ldap_v2     boolean false
libpam-runtime  libpam-runtime/profiles multiselect     unix, ldap, systemd, capability
ldap-auth-config        ldap-auth-config/ldapns/base-dn string  dc=clemson,dc=cloudlab,dc=us
ldap-auth-config        ldap-auth-config/dbrootlogin    boolean true
ldap-auth-config        ldap-auth-config/ldapns/ldap_version    select  3
ldap-auth-config        ldap-auth-config/rootbinddn     string  cn=admin,dc=clemson,dc=cloudlab,dc=us
ldap-auth-config        ldap-auth-config/ldapns/ldap-server     string  ldap://192.168.1.1
ldap-auth-config        ldap-auth-config/move-to-debconf        boolean true
" | sudo debconf-set-selections

sed 's/compat systemd/compat systemd ldap/ /etc/nsswitch.conf
