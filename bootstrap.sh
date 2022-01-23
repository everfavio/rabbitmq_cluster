export DEBIAN_FRONTEND=noninteractive

#!/usr/bin/env bash
# instalamos los paquetes necesario
sudo apt-get update

#configurando ssh user
sed -i "/^[^#]*PasswordAuthentication[[:space:]]no/c\PasswordAuthentication yes" /etc/ssh/sshd_config
systemctl restart sshd.service
## creamos el usuario
useradd -m -s /bin/bash ubuntu
## establecemos la contraseña ('usuario:password')
echo 'ubuntu:ubuntu' | chpasswd
## agregamos al nuevo usuario al grupo sudoers
echo 'ubuntu  ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
## generamos las llaves ssh para habilitar la autenticación ssh
