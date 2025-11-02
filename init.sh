#!/bin/bash
# --- AiProb v7.2-rc CORE Installer (init.sh) - FINAL ANTI-ERROR ---
# FUNGSI: Mengunduh semua Part dan mengeksekusi instalasi secara berurutan.

set -e

# --- KONFIGURASI CORE LOGIC ---
GITHUB_RAW_BASE="https://raw.githubusercontent.com/jtsi-project/AiProb-Core/main"
CORE_VERSION="v7.2-rc"

echo "========================================================="
echo "== AiProb v$CORE_VERSION: Instalasi Core (JTSI) =="
echo "========================================================="
echo "Memulai proses instalasi modular..."

# --- 1. DOWNLOAD SEMUA PART CORE LOGIC ---
echo "[SETUP] Mengunduh komponen instalasi modular..."
# Pastikan nama file di sini sama persis dengan yang ada di GitHub
CORE_PARTS=("setup_prerequisites.sh" "create_app_files.py" "finalize_ux.py" "app_core.py.code" "runner_template.sh.code" "requirements.txt")

for part in "${CORE_PARTS[@]}"; do
    FILE_URL="$GITHUB_RAW_BASE/$part"
    echo "  -> Mendapatkan $part..."
    
    # Gunakan cURL/Wget dan pastikan file tidak kosong (mengatasi masalah 404/file corrupted)
    if command -v curl &> /dev/null; then
        curl -sSL -o "$part" "$FILE_URL"
    elif command -v wget &> /dev/null; then
        wget -q -O "$part" "$FILE_URL"
    else
        echo "ERROR: curl atau wget tidak ditemukan. Instalasi dibatalkan."
        exit 1
    fi

    if [ ! -s "$part" ]; then
         echo "❌ ERROR GAGAL UNDUH: $part kosong atau tidak ditemukan di GitHub."
         exit 1
    fi

    chmod +x "$part"
done

# --- 2. EKSEKUSI FASE 1: PENYIAPAN LINGKUNGAN ---
echo ""
echo "--- [FASE 1: PRE-CHECK & LINGKUNGAN] ---"
./setup_prerequisites.sh || { echo "❌ ERROR: FASE 1 (Setup Lingkungan) GAGAL."; exit 1; }

# Variabel diset di setup_prerequisites.sh. Kita aktifkan VENV di sini:
. .venv_aiprob/bin/activate
PYTHON_BIN_FULL=$(which python)
echo "✅ Lingkungan virtual diaktifkan: $PYTHON_BIN_FULL"

# --- 3. EKSEKUSI FASE 2: PEMBUATAN FILE ---
echo ""
echo "--- [FASE 2: PEMBUATAN FILE PROYEK] ---"
# Skrip Python akan membaca variabel dari shell environment
$PYTHON_BIN_FULL ./create_app_files.py "$CORE_VERSION" || { echo "❌ ERROR: FASE 2 (Pembuatan File) GAGAL."; deactivate; exit 1; }

# --- 4. EKSEKUSI FASE 3: USER EXPERIENCE AKHIR ---
echo ""
echo "--- [FASE 3: PANDUAN AKHIR] ---"
# Panggil Python script untuk UX dan Menu Interaktif
$PYTHON_BIN_FULL ./finalize_ux.py "$CORE_VERSION" || { echo "❌ ERROR: FASE 3 GAGAL."; deactivate; exit 1; }

# Jika skrip sampai di sini tanpa error, nonaktifkan venv shell saat ini.
deactivate
