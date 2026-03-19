# --- Otimizando Hardware de Rede ---
# Descobre o nome da interface de rede ativa (ex: enp3s0)
INTERFACE=$(ip route | grep default | awk '{print $5}' | head -n1)
if [ -n "$INTERFACE" ]; then
     echo "--- Otimizando Hardware (Interface: $INTERFACE) ---"
     sudo ethtool -C "$INTERFACE" rx-usecs 0 tx-usecs 0
     sudo ethtool --set-eee "$INTERFACE" eee off
else
    echo "Aviso: Interface de rede ativa não encontrada."
fi

# --- Processo do Jogo ---
echo "--- Aguardando o Elite Dangerous (Steam/Proton) ---"
# Loop que espera o jogo abrir para capturar o PID
PID=""
while [ -z "$PID" ]; do
      PID=$(pgrep -f "EliteDangerous64.exe")
      sleep 2
done
echo "Jogo detectado! PID: $PID"
sudo renice -n -10 -p $PID

echo "Configurações aplicadas com sucesso. Boa caça, Comandante, o7!"
sleep 3
