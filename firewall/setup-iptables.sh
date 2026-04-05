#!/bin/bash

# ==========================================
# Script de Configuração do Roteador/Firewall
# ==========================================

echo "Aplicando regras de Firewall e NAT..."

# 1. Limpar regras antigas
iptables -F
iptables -t nat -F
iptables -X

# 2. Definir Políticas Padrão (Privilégio Mínimo)
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# 3. Tráfego Local e Conexões Estabelecidas
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT

# 4. Permitir acesso à porta SSH no roteador
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# 5. Permitir acesso da rede interna (enp0s8) ao roteador (DNS, DHCP, etc)
iptables -A INPUT -i enp0s8 -j ACCEPT

# 6. Ativar NAT (Masquerade) para a placa de saída (enp0s3)
iptables -t nat -A POSTROUTING -o enp0s3 -j MASQUERADE

# ==========================================
# EGRESS FILTERING (Controle de Saída)
# ==========================================

# 7. Liberar DNS (UDP/TCP 53)
iptables -A FORWARD -i enp0s8 -o enp0s3 -p udp --dport 53 -j ACCEPT
iptables -A FORWARD -i enp0s8 -o enp0s3 -p tcp --dport 53 -j ACCEPT

# 8. Liberar Navegação Web (HTTP 80 e HTTPS 443)
iptables -A FORWARD -i enp0s8 -o enp0s3 -p tcp --dport 80 -j ACCEPT
iptables -A FORWARD -i enp0s8 -o enp0s3 -p tcp --dport 443 -j ACCEPT

# 9. Bloquear PING (ICMP) para a internet
iptables -A FORWARD -i enp0s8 -o enp0s3 -p icmp -j DROP

# 10. Ativar log de pacotes bloqueados no FORWARD
iptables -A FORWARD -j LOG --log-prefix " DROP_FORWARD: "

echo "Regras aplicadas com sucesso!"
