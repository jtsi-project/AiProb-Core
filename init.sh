#!/bin/bash
# --- AiProb Master Installer (init.sh) ---
# FUNGSI: Mengunduh skrip instalasi utama dari Repo Installer.
# Pengembang: Anjas Amar Pradana / JTSI

set -e
# URL untuk mengunduh installer.sh dari Repo Installer
GITHUB_INSTALLER_RAW_URL="https://raw.githubusercontent.com/jtsi-project/AiProb/main/installer.sh"

echo "================================================="
echo "== AiProb v7.2 Installer Master (INIT) =="
echo "================================================="
echo "Skrip ini akan mengunduh installer utama dari repositori 'AiProb' Anda."

if [ -f "installer.sh" ]; then
    echo "🚨 PERINGATAN: File 'installer.sh' sudah ada di direktori ini."
    read -p "  -> Apakah Anda ingin menghapus 'installer.sh' lama dan mengunduh yang baru? [Y/n] " PERSETUJUAN
    if [ "$PERSETUJUAN" != "y" ] && [ "$PERSETUJUAN" != "Y" ] && [ "$PERSETUJUAN" != "" ]; then
        echo "Installer Master dibatalkan. Silakan jalankan ./installer.sh secara langsung."
        exit 0
    fi
    rm -f installer.sh
fi

echo "[1/2] Mengunduh skrip instalasi utama ('installer.sh')..."
if command -v curl &> /dev/null; then
    curl -sSL -o installer.sh "$GITHUB_INSTALLER_RAW_URL"
elif command -v wget &> /dev/null; then
    wget -q -O installer.sh "$GITHUB_INSTALLER_RAW_URL"
else
    echo "ERROR: curl atau wget tidak ditemukan. Tidak dapat mengunduh installer.sh."
    exit 1
fi

if [ ! -f "installer.sh" ]; then
    echo "ERROR: Pengunduhan gagal. Cek koneksi atau URL GitHub: $GITHUB_INSTALLER_RAW_URL"
    exit 1
fi

chmod +x installer.sh
echo "✅ Pengunduhan berhasil. Izin eksekusi diberikan."

echo "[2/2] Mengalihkan ke Installer Utama..."
echo "-------------------------------------------------"
echo "Silakan jalankan skrip yang baru diunduh untuk melanjutkan instalasi:"
echo "   ./installer.sh"
echo "-------------------------------------------------"
