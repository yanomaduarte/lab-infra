# 🌐 Laboratório de Infraestrutura: Roteador Linux com NAT, DHCP e Firewall
# Yanomã Duarte e Francisco Fernando

![Ubuntu](https://img.shields.io/badge/OS-Ubuntu_Server_24.04-orange?style=flat-square&logo=ubuntu)
![Firewall](https://img.shields.io/badge/Security-iptables-blue?style=flat-square)
![Network](https://img.shields.io/badge/Network-DHCP_%7C_NAT-success?style=flat-square)

## 📌 Sobre o Projeto
Este projeto documenta a construção e configuração de uma infraestrutura de rede simulada utilizando máquinas virtuais. O objetivo foi transformar um servidor Linux em um roteador funcional, aplicando conceitos essenciais de administração de redes e segurança.

O servidor gerencia a rede local distribuindo endereços IP automaticamente, realizando a tradução de endereços (NAT) para acesso à internet e filtrando o tráfego de saída (Egress Filtering) sob o princípio de "Privilégio Mínimo" — onde tudo é bloqueado por padrão e apenas serviços essenciais são permitidos.

---

## 🏗️ Topologia da Rede

<img width="449" height="476" alt="image" src="https://github.com/user-attachments/assets/f0d9271f-6849-42ce-b6f1-c604b86c7903" />

* **Internet:** Conexão externa via hypervisor (VirtualBox).
* **Servidor (Roteador Linux):**
    * `enp0s3`: Interface WAN (NAT / DHCP Client).
    * `enp0s8`: Interface LAN (Rede Interna / IP Fixo: `192.168.20.1/24`).
* **Cliente (Ubuntu Desktop):**
    * `enp0s3`: Interface LAN (Rede Interna / IP Dinâmico via DHCP do Servidor).

---

## ⚙️ Tecnologias e Serviços Implementados

* **Netplan:** Configuração declarativa de IP estático na interface local.
* **isc-dhcp-server:** Servidor DHCP para entrega dinâmica de IPs no escopo `192.168.20.100` a `192.168.20.200`.
* **IP Forwarding:** Roteamento ativado no Kernel do Linux (`sysctl`).
* **iptables (Netfilter):** * **NAT (Masquerade):** Para permitir que a rede interna acesse a internet.
    * **Stateful Firewall:** Permissão de tráfego ESTABLISHED e RELATED.
    * **Egress Filtering:** Regras de saída restritas (Portas 53 UDP/TCP, 80 TCP e 443 TCP). Bloqueio de ICMP (Ping) para a internet.
    * **iptables-persistent:** Para garantir que as regras sobrevivam à reinicialização do sistema.

---

## 📁 Estrutura do Repositório

Neste repositório, você encontra os arquivos de configuração idênticos aos aplicados no servidor:

- `/netplan/` -> Arquivo `.yaml` com as definições de interface.
- `/dhcp/` -> Arquivos `dhcpd.conf` e `isc-dhcp-server` com o escopo da rede.
- `/firewall/` -> Arquivo de texto contendo as regras aplicadas via `iptables`.

---

## 🧪 Validação e Testes (Evidências)

Abaixo estão os testes realizados na máquina Cliente que comprovam a eficácia das regras aplicadas no servidor:

### 1. Entrega de IP (DHCP) e Comunicação Local
O cliente obteve sucesso ao receber o IP e pingar o Gateway da rede.
<img width="1058" height="692" alt="image" src="https://github.com/user-attachments/assets/f8d01ced-00f1-4c7c-84f4-abbf35b6e09e" />

### 2. Resolução de Nomes e Navegação (NAT e Liberação DNS/HTTPS)
Testes confirmam que o roteador mascara o IP da LAN e o firewall permite consultas DNS e requisições Web.
<img width="1205" height="422" alt="image" src="https://github.com/user-attachments/assets/d06bbd9a-e366-45f9-a6d9-27e0eb0570b0" />

### 3. Bloqueio de Tráfego Não Autorizado
Como o firewall segue a política padrão de DROP, requisições externas não autorizadas (como ICMP) são bloqueadas com sucesso, garantindo o Egress Filtering.
<img width="490" height="91" alt="image" src="https://github.com/user-attachments/assets/872a1e7b-5375-4785-a835-bd20718cd89e" />

---
*Projeto desenvolvido para fins de estudo em infraestrutura de redes.*
