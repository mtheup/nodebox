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

PKGS="live-build debootstrap squashfs-tools xorriso mtools dosfstools"
case "$(dpkg --print-architecture)" in
    amd64) PKGS="$PKGS grub-pc-bin grub-efi-amd64-bin" ;;
    arm64) PKGS="$PKGS grub-efi-arm64-bin" ;;
esac

echo ">> Instalando dependências de build..."
apt-get update
apt-get install -y $PKGS

chmod +x auto/config config/hooks/live/*.hook.* config/includes.chroot/usr/local/bin/*

echo ">> Limpando build anterior..."
lb clean --purge || true

echo ">> Configurando ($ARCH)..."
ARCH="$ARCH" lb config

echo ">> Construindo a ISO (pode levar de 15 a 40 min)..."
lb build 2>&1 | tee build.log

echo ">> Pronto:"
ls -lh ./*.iso
