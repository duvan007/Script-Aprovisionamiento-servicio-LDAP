provisionamiento Automatizado de OpenLDAP y BIND9 (DNS)

Este repositorio contiene un script de Bash diseñado para automatizar el aprovisionamiento desatendido de un servidor de directorio OpenLDAP y un servidor de nombres BIND9 en entornos basados en Debian/Ubuntu.
🚀 Descripción del Proyecto

El script Aprovisionamiento_LDAP_BLIND_deb.sh facilita la implementación rápida de una infraestructura base para la gestión de identidades y resolución de nombres, ideal para laboratorios de pruebas, entornos de desarrollo o nodos de gestión en redes locales.
Características Principales:

    Instalación Desatendida: Utiliza debconf-set-selections para pre-configurar los parámetros de OpenLDAP (dominio, organización y contraseñas) sin intervención humana.

    Configuración de BIND9: Implementa un servidor DNS con:

        Zonas Forward y Reverse: Configuración completa para el dominio velasquez.net.

        Recursión y Forwarders: Configurado para resolver consultas externas vía Google DNS (8.8.8.8).

    Manejo de Infraestructura Híbrida: El script ya contempla el mapeo de IPs para servidores de bases de datos, servidores web y nodos de Ansible.

🛠️ Tecnologías Utilizadas

    Lenguaje: Bash Scripting.

    Directorio: OpenLDAP (slapd, ldap-utils).

    DNS: BIND9.

    Sistemas Operativos: Debian / Ubuntu.

📋 Requisitos Previos

    Un sistema operativo basado en Debian instalado.

    Privilegios de superusuario (root o sudo).

    Conexión a internet para la descarga de paquetes.

⚙️ Configuración y Uso

    Clonar el repositorio:
    Bash

    git clone https://github.com/tu-usuario/nombre-del-repo.git
    cd nombre-del-repo

    Personalizar variables:
    Edita las variables al inicio del script (DOMAIN, BASE_DN, LDAP_ADMIN_PASS) según tus necesidades de red.

    Asignar permisos de ejecución:
    Bash

    chmod +x Aprovisionamiento_LDAP_BLIND_deb.sh

    Ejecutar el script:
    Bash

    sudo ./Aprovisionamiento_LDAP_BLIND_deb.sh

Attach files by dragging & dropping, selecting or pasting them.
Attach files by dragging & dropping, selecting or pasting them.
Attach files by dragging & dropping, selecting or pasting them.
Attach files by dragging & dropping, selecting or pasting them.


👤 Autor

Jorge Duvan Velasquez Ramirez

    Ingeniero en Sistemas (En curso).

    Especialista en Infraestructura y Administración de Servidores Linux/Windows.
