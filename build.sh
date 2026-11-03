#!/bin/bash
# Gera a ISO da NodeBox. Rode em Debian/Ubuntu com sudo.
# Uso: sudo ./build.sh [amd64|arm64]
set -euo pipefail

ARCH="${1:-amd64}"
cd "$(dirname "$0")"

if [ "$(id -u)" -ne 0 ]; then
    echo "Rode com sudo: sudo ./build.sh $ARCH" >&2
    exit 1
fi

echo ">> Instalando dependências de build..."
apt-get update
apt-get install -y live-build debootstrap squashfs-tools xorriso \
    grub-pc-bin grub-efi-amd64-bin grub-efi-arm64-bin mtools dosfstools \
    qemu-user-static binfmt-support

chmod +x auto/config config/hooks/live/*.hook.chroot

echo ">> Limpando build anterior..."
lb clean --purge || true

echo ">> Configurando ($ARCH)..."
ARCH="$ARCH" lb config

echo ">> Construindo a ISO (pode levar de 15 a 40 min)..."
lb build 2>&1 | tee build.log

echo ">> Pronto:"
ls -lh ./*.iso
