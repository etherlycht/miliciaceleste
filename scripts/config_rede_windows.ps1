# --- Otimizações de Rede (TCP Stack) ---
Write-Host "--- Aplicando Otimizações de Baixa Latência e TCP ---" -ForegroundColor Cyan

# Equivalente ao TCP Low Latency e BBR (Windows usa o algoritmo CUBIC ou Compound por padrão)
# Habilita o ajuste de recebimento de janela para 'HighlyRestricted' para reduzir latência
netsh int tcp set global autotuninglevel=highlyrestricted
netsh int tcp set global ecncapability=enabled
netsh int tcp set global timestamps=disabled
netsh int tcp set global rss=enabled

# Equivalente ao tcp_low_latency e redução de retransmissão
netsh int tcp set global initialrto=2000
netsh int tcp set global nonsackrttresiliency=disabled

# --- Otimizando Hardware de Rede (NIC) ---
# Desativa o "Energy Efficient Ethernet" (EEE) e o "Green Ethernet" que causam picos de lag
Write-Host "--- Otimizando Hardware de Rede (Desativando Economia de Energia) ---" -ForegroundColor Yellow
Get-NetAdapter | Where-Object { $_.Status -eq "Up" } | ForEach-Object {
    Disable-NetAdapterPowerManagement -Name $_.Name -NoRestart
    Set-NetAdapterAdvancedProperty -Name $_.Name -DisplayName "Energy Efficient Ethernet" -DisplayValue "Disabled" -ErrorAction SilentlyContinue
    Set-NetAdapterAdvancedProperty -Name $_.Name -DisplayName "Green Ethernet" -DisplayValue "Disabled" -ErrorAction SilentlyContinue
}

# --- Processo do Jogo (Prioridade de CPU) ---
Write-Host "--- Aguardando o Elite Dangerous (EliteDangerous64.exe) ---" -ForegroundColor Cyan

$PID_Game = $null
while ($null -eq $PID_Game) {
    $PID_Game = Get-Process -Name "EliteDangerous64" -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
}

Write-Host "Jogo detectado! PID: $($PID_Game.Id)" -ForegroundColor Green

# Equivalente ao 'renice -10'. No Windows, mudamos a classe de prioridade.
# "AboveNormal" é o equivalente seguro. "High" pode causar instabilidade no sistema.
$PID_Game.PriorityClass = 'AboveNormal'

Write-Host "Configurações aplicadas com sucesso. Boa caça, Comandante, o7!" -ForegroundColor Green
Start-Sleep -Seconds 3
