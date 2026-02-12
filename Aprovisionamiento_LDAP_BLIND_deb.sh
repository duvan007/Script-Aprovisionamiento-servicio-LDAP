#!/bin/bash

# Variables configurables, edita estas variables de acuerdo con los parametros que necesitas
DOMAIN="velasquez.net"
BASE_DN="dc=velasquez,dc=net"
ORG_NAME="velasquez"  # Organización (primer componente del dominio)
LDAP_ADMIN_PASS="AdminPass123"  # ¡Cambia por una contraseña segura!

echo "Actualizando sistema..."
apt update && apt upgrade -y

echo "Pre-configurando OpenLDAP de forma desatendida..." # con debconf-set-selections para intrudicir parametros de #configuracion directamente en bd del SO previo al proceso de configuracion.
cat <<EOF | debconf-set-selections
slapd slapd/internal/adminpw password ${LDAP_ADMIN_PASS}
slapd slapd/internal/generated_adminpw password ${LDAP_ADMIN_PASS}
slapd slapd/password1 password ${LDAP_ADMIN_PASS}
slapd slapd/password2 password ${LDAP_ADMIN_PASS}
slapd slapd/domain string ${DOMAIN}
shared shared/organization string ${ORG_NAME}
slapd slapd/purge_database boolean false
slapd slapd/move_old_database boolean true
slapd slapd/backend select HDB  # o MDB en versiones más nuevas
EOF

echo "Instalando OpenLDAP (slapd y herramientas)..."
DEBIAN_FRONTEND=noninteractive apt install -y slapd ldap-utils

echo "Instalando BIND9..."
apt install bind9 bind9utils bind9-doc -y

echo "Configurando BIND9..."
cat > /etc/bind/named.conf.options << EOF
options {
    directory "/var/cache/bind";
    listen-on { 127.0.0.1; 192.168.80.103; };  # Cambia por tu IP
    allow-query { localhost; 192.168.80.0/24; }; # campia por la ipd de red o redes
    recursion yes;
    forwarders { 8.8.8.8; 8.8.4.4; };
};
EOF

# Zona forward
cat > /etc/bind/named.conf.local << EOF
zone "${DOMAIN}" {
    type master;
    file "/etc/bind/db.${DOMAIN}";
};

zone "80.168.192.in-addr.arpa" {
    type master;
    file "/etc/bind/db.192";
};
EOF

# Archivo de zona forward
cat > /etc/bind/db.${DOMAIN} << EOF
\$TTL    604800
@       IN      SOA     ns1.${DOMAIN}. root.${DOMAIN}. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       	IN      NS      ns1.${DOMAIN}.
ns1    		IN      A       192.168.80.103   ; IP del servidor dns
udesktop     	IN      A       192.168.80.100    ; nodo servidor ansible
server1      	IN      A       192.168.80.101    ; web server
server2      	IN      A       192.168.80.102    ; DB server
ldapserver  	IN      A       192.168.80.103   ; ldap/dns
EOF

# Archivo de zona reverse (Red 192.168.80.x)
cat > /etc/bind/db.192.168.80 << EOF
\$TTL    604800
@       IN      SOA     ns1.${DOMAIN}. root.${DOMAIN}. (
                              3         ; Serial (incrementado)
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      ns1.${DOMAIN}.

; Mapeo de IPs a Nombres (IP -> Nombre)
100     IN      PTR     udesktop.${DOMAIN}.
101     IN      PTR     server1.${DOMAIN}.
102     IN      PTR     server2.${DOMAIN}.
103     IN      PTR     ldapserver.${DOMAIN}.
103     IN      PTR     ns1.${DOMAIN}.
EOF

systemctl restart named


echo "Instalación completada. Prueba con: ldapsearch -x -b '${BASE_DN}' y dig @localhost ${DOMAIN}"
