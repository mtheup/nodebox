# NodeBox 

Seu servidor, seu sistema!

Baseado em Debian 13, Com ferramentas para voce e seu server

## Entrar

- Usuário: `node` — senha: `node` (tem `sudo`; **troque com `passwd`**)
- Teclado ABNT2, fuso America/Sao_Paulo

## Menu de boot

- **Live system**: sobe o sistema; no tty1, depois do login, o i3 abre sozinho.
- **Live CLI (sem interface grafica)**: só terminal, o i3 não é iniciado (parâmetro `nbmode=cli`).

Nos dois modos há um segundo terminal em `Ctrl+Alt+F2` (no VirtualBox: Ctrl direito + F2).

## Ferramentas `nb`

```
nb status                       memória, disco, portas, apps e serviços com falha
nb mem [N]                      maiores consumidores de memória
nb app create <nome> [--port N] [--mem MB] [--entry arquivo.js]
nb app list | start | stop | restart | status | logs [-f] | rm
nb proxy add <dominio> <porta>  site no nginx apontando para o app
nb ssl <dominio> [email]        HTTPS com certbot (instala na hora)
nb fw setup                     firewall: libera 22, 80 e 443
nb ssh addkey "<chave>"         cadastra chave pública
nb ssh harden                   desliga login por senha
nb swap create 2G               swap (só após instalar em disco)
nb backup                       compacta /srv/apps
nb update                       atualiza o sistema
nb install <extra>              fail2ban, certbot, build-tools, redis, postgres, ...
```

Apps rodam como serviços systemd (sem pm2), com limite de memória por app.
Coloque o código em `/srv/apps/<nome>` e use `nb app create <nome>`.

## O que foi cortado para economizar memória

Sem gerenciador de login (lightdm), navegador, NetworkManager, chrony, fail2ban,
unattended-upgrades, certbot, build-essential e pm2 instalados por padrão.
Rede com systemd-networkd, hora com systemd-timesyncd, logs só em RAM (máx. 32 MB),
2 consoles, timers de apt desligados. Tudo que foi cortado pode voltar com `nb install`.

## Gerar a ISO

Pelo GitHub Actions (aba Actions → Build NodeBox ISO → Run workflow) ou localmente:

```bash
sudo ./build.sh amd64      # ou arm64
```

## Estrutura

```
auto/config                              parâmetros do live-build
config/package-lists/                    pacotes instalados
config/hooks/live/*.hook.chroot          scripts rodados dentro da imagem (ordem numérica)
config/hooks/live/0900-live-cli.hook.binary   adiciona "Live CLI" nos menus de boot
config/includes.chroot/                  arquivos copiados para o sistema (nb, nb-health, i3, systemd, ssh)
```
