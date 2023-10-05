#Definir el nom del host
hostnamectl set-hostname master

#Assignar nomes a les diferents IPs
echo "127.0.0.1 localhost
127.0.1.1       master

20.20.21.68     worker" > /etc/hosts

#Configurar l'encaminament de paquets amb iptables
iptables -t nat -A POSTROUTING -s 20.20.20.0/23 -o ens3 -j SNAT --to 10.10.11.182
iptables -t nat -A POSTROUTING -o ens3 -j MASQUERADE
iptables -A FORWARD -i ens3 -o ens4 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i ens4 -o ens3 -j ACCEPT


#Activar el forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward
sysctl -p

#Reboot
systemctl restart networking


