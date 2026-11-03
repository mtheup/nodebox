# NodeBox — distro Linux simples para servidor Node.js

Base: **Debian 13 (trixie)** via `live-build`. Desktop: **i3** (mínimo, opcional no dia a dia).
Pensada para uma máquina de **2 vCPU / 12 GB RAM**.

## O que vem na ISO

- Node.js + npm, e globalmente: pm2, yarn, pnpm
- nginx (proxy reverso) + certbot (SSL)
- openssh-server endurecido, ufw, fail2ban, unattended-upgrades, chrony
- sysctl e limites de arquivos ajustados para servidor
- i3 + lightdm + firefox-esr para uso gráfico local
- Diretório `/srv/apps` para seus projetos

## Como gerar a ISO

Numa máquina Debian/Ubuntu (ou VM/WSL2) com internet:

```bash
cd nodebox
sudo ./build.sh amd64     # PCs / VMs comuns
sudo ./build.sh arm64     # Oracle Ampere A1, Raspberry etc.
```

A ISO sai na pasta `nodebox/` (`nodebox-*.iso`).

## Primeiro uso

- Usuário: `node` / senha padrão do live-build: `live` — **troque com `passwd`**
- Teste antes no QEMU: `qemu-system-x86_64 -m 4096 -cdrom nodebox-amd64.hybrid.iso`
- Para iniciar o i3 no terminal: `startx`

## Estrutura

```
auto/config                     parâmetros do live-build
config/package-lists/           pacotes instalados
config/hooks/live/              scripts rodados dentro da imagem
config/includes.chroot/         arquivos copiados para o sistema (ssh, sysctl, i3, motd)
build.sh                        script de build
```

## Observações

- A ISO é um sistema **live**. Para instalar em disco, o instalador do Debian pode ser
  adicionado depois (`--debian-installer live` já está configurado).
- Em nuvem (ex.: Oracle), normalmente se usa imagem de disco, não ISO; posso gerar uma variante `.qcow2` / `.img`.
