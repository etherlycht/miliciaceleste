# Guia de Aprimoramentos e Configuração - Elite Dangerous
Este guia detalha as melhorias recomendadas para estabilidade de conexão e performance além de configurações ULTRA+.

## 1. Otimização de Instâncias (P2P)
O Elite Dangerous utiliza uma arquitetura Peer-to-Peer. Para evitar quedas ao entrar em estações ou zonas de conflito:
* Verifique se o seu roteador suporta UPnP.
* Ajuste o MTU se necessário (veja o script de rede).

## 2. Configurações de Rede
O script fornecido na página inicial automatiza as seguintes tarefas:
1. Limpeza de cache de DNS.
2. Reset do stack TCP/IP.
3. Ajuste de prioridade de pacotes para o jogo.

## 3. A maioria dos comandos para otimização de rede podem ser estaticos no arquivo sysctl como 
### --- Otimizações de Kernel e Rede (Sysctl) ---
echo "--- Aplicando Otimizações de Baixa Latência e TCP ---"

### Memória e Swap
sudo sysctl -w vm.swappiness=10
### ou
cat /proc/sys/vm/swappiness (valor normal 60, isso diminui a necessidade de swap que retarda a ram)

echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf 

sudo sysctl -p

### Protocolos de Congestionamento e Fila
sudo sysctl -w net.core.default_qdisc=fq

sudo sysctl -w net.ipv4.tcp_congestion_control=bbr

### ou 
sudo modprobe tcp_bbr

lsmod | grep bbr

sudo sysctl net.ipv4.tcp_congestion_control

se não estiver funcionando:

sudo sysctl -w net.core.default_qdisc=fq

sudo sysctl -w net.ipv4.tcp_congestion_control=bbr

### verificar novamente
sysctl net.ipv4.tcp_congestion_control

### Latência e Timers TCP
sudo sysctl -w net.ipv4.tcp_low_latency=1

sudo sysctl -w net.ipv4.tcp_tw_reuse=1

sudo sysctl -w net.ipv4.tcp_fin_timeout=15

sudo sysctl -w net.ipv4.tcp_slow_start_after_idle=0

### ou
echo "net.core.default_qdisc=fq" | sudo tee -a /etc/sysctl.conf 

echo "net.ipv4.tcp_congestion_control=bbr" | sudo tee -a /etc/sysctl.conf 

echo "net.ipv4.tcp_low_latency=1" | sudo tee -a /etc/sysctl.conf 

sudo sysctl -p

### Buffers de Memória de Rede
sudo sysctl -w net.core.rmem_max=16777216

sudo sysctl -w net.core.wmem_max=16777216

sudo sysctl -w net.core.netdev_max_backlog=5000

sudo sysctl -w net.core.dev_weight=64

### ou
echo "net.core.rmem_max=16777216" | sudo tee -a /etc/sysctl.conf

echo "net.core.wmem_max=16777216" | sudo tee -a /etc/sysctl.conf 

echo "net.core.netdev_max_backlog=5000" | sudo tee -a /etc/sysctl.conf 

echo "net.core.dev_weight=64" | sudo tee -a /etc/sysctl.conf 

### para abrir mais rapido os programas:

sudo apt install preload

## 4. Configurações Gráficas

### Localize e copie o arquivo:
/home/dvtra/.steam/steam/steamapps/common/Elite Dangerous/Products/elite-dangerous-odyssey-64/GraphicsConfiguration.xml

### Colar e alter em:
/home/dvtra/.steam/steam/steamapps/compatdata/359320/pfx/drive_c/users/steamuser/AppData/Local/Frontier Developments/Elite Dangerous/Options/Graphics

### Linhas a sertem alteradas:
### 4.1  Em DirectionalShadows_Ultra:
(Todas as cinco linhas contendo as Sombras direcionais)

Cascade

CellResolution 4096 CellResolution

### 4.2 Em Planets:
Ultra

LocalisationName QUALITY_ULTRA LocalisationName

TextureSize 4096 TextureSize

AtmosphereSteps 6 AtmosphereSteps

CloudsEnabled true CloudsEnabled

WorkPerFrame 512 WorkPerFrame

TexturePoolBudget 100 TexturePoolBudget

### 4.3 Em GalaxyBackground:
High

LocalisationName QUALITY_HIGH LocalisationName

TextureSize 4096 TextureSize

High
    
### 4.5. Em BLOOM:
Ultra

LocalisationName QUALITY_ULTRA LocalisationName

Method ImprovedCustomPassCount Method

MinThreshold 0.0 MinThreshold

MaxThreshold 0.375 MaxThreshold

GlareScale 0.06 GlareScale

ThresholdType 4 ThresholdType

FilterRadius 3.0 FilterRadius

FilterRadiusWide 4.0 FilterRadiusWide

Ultra

### 4.6 Em Envmap:
High

LocalisationName QUALITY_HIGH LocalisationName

TextureSize 1024 TextureSize

NumMips 8 NumMips

High

#### P.S.: O efeito BLOOM pode variar mais como:
MaxThreshold 0.4375 MaxThreshold

GlareScale 0.07 GlareScale 
##### Ou
MaxThreshold 0.5 MaxThreshold

GlareScale 0.08 GlareScale
##### Testei com sucesso até
MinThreshold 0.30 MinThreshold

MaxThreshold 500.0 MaxThreshold 

GlareScale 0.55 GlareScale

ThresholdType 4 ThresholdType 

FilterRadius 3.0 FilterRadius 

FilterRadiusWide 5.0 FilterRadiusWide 



> **Aviso:** Execute o script como Administrador, e mantenha os símbolos no arquivo .xml para que as alterações tenham efeito.
