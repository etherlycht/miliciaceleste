#!/bin/bash

# --- Otimizações de Kernel e Rede (Sysctl) ---
echo "--- Aplicando Otimizações de Baixa Latência e TCP ---"

# Memória e Swap
sudo sysctl -w vm.swappiness=10

# Protocolos de Congestionamento e Fila
sudo sysctl -w net.core.default_qdisc=fq
sudo sysctl -w net.ipv4.tcp_congestion_control=bbr

# Latência e Timers TCP
sudo sysctl -w net.ipv4.tcp_low_latency=1
sudo sysctl -w net.ipv4.tcp_tw_reuse=1
sudo sysctl -w net.ipv4.tcp_fin_timeout=15
sudo sysctl -w net.ipv4.tcp_slow_start_after_idle=0

# Buffers de Memória de Rede
sudo sysctl -w net.core.rmem_max=16777216
sudo sysctl -w net.core.wmem_max=16777216
sudo sysctl -w net.core.rmem_default=16777216
sudo sysctl -w net.core.wmem_default=16777216
sudo sysctl -w net.core.netdev_max_backlog=5000
sudo sysctl -w net.ipv4.udp_mem=1536000
sudo sysctl -w net.core.dev_weight=64

# --- Otimizando Hardware de Rede ---
# Descobre o nome da interface de rede ativa (ex: enp3s0)
INTERFACE=$(ip route | grep default | awk '{print $5}' | head -n1)
if [ -n "$INTERFACE" ]; then
     echo "--- Otimizando Hardware (Interface: $INTERFACE) ---"
     # Desativa coalescência (latência instantânea) e economia de energia (EEE)
     sudo ethtool -C "$INTERFACE" rx-usecs 0 tx-usecs 0
     sudo ethtool --set-eee "$INTERFACE" eee off
else
    echo "Aviso: Interface de rede ativa não encontrada."
fi

# --- Processo do Jogo ---
echo "--- Aguardando o Elite Dangerous (Wine) ---"
# Loop que espera o jogo abrir para capturar o PID
PID=""
while [ -z "$PID" ]; do
      PID=$(pgrep -f "EliteDangerous64.exe")
      sleep 2
done
echo "Jogo detectado! PID: $PID"
sudo renice -n -10 -p $PID

# Prioridade de CPU em tempo real (Round Robin) para o processo
# Isso ajuda muito a evitar stutters em processadores com muitos núcleos
sudo chrt -r -p 10 $PID

echo "Configurações aplicadas com sucesso. Boa caça, Comandante, o7!"
sleep 3
