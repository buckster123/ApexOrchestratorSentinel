#!/bin/bash

# install.sh: Auto-install for ApexSentinel on fresh Raspberry Pi OS Bookworm (Pi-5)
# Run as: sudo bash install.sh (from project dir)
# Logs to install.log
# Enhanced: PiSense deps (cam, GPIO, pigpiod)

set -e  # Exit on error
LOGFILE="install.log"
exec > >(tee -a ${LOGFILE})
exec 2> >(tee -a ${LOGFILE} >&2)

echo "=== ApexSentinel Install Script ==="
echo "Date: $(date)"
echo "Starting on: $(uname -a)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# Check if running on Pi-5/Bookworm
if ! grep -q "Raspberry Pi 5" /proc/cpuinfo; then
    warn "Not detected as Pi-5; proceeding anyway (ensure 64-bit Bookworm)."
fi
if ! grep -q "bookworm" /etc/os-release; then
    warn "Not Bookworm; some deps may fail."
fi

# Step 1: System Update
log "Updating system..."
sudo apt update && sudo apt upgrade -y

# Step 2: Install apt dependencies (core + PiSense)
log "Installing apt packages..."
sudo apt install -y \
    build-essential \
    cmake \
    libgit2-dev \
    python3-pip \
    python3-venv \
    git \
    clang-tools \
    golang-go \
    php-cli \
    composer \
    curl \
    ntp \
    python3-picamera2 \
    python3-gpiozero \
    libcamera-apps \
    gpiod \
    pigpio \
    || error "Apt install failed. Check log."

# Enable Pi Cam & GPIO
log "Enabling camera and GPIO..."
sudo raspi-config nonint do_camera 0  # Enable camera
sudo systemctl enable pigpiod
sudo systemctl start pigpiod

# Step 3: Install php-cs-fixer
log "Installing php-cs-fixer..."
sudo composer global require friendsofphp/php-cs-fixer || warn "Composer global failed; PHP linting disabled."

# Step 4: Install Rust (for rustfmt)
log "Installing Rust (rustup)..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"
rustup component add rustfmt || warn "Rustfmt add failed; Rust linting disabled."

# Step 5: Create virtual environment
log "Setting up Python venv..."
python3 -m venv venv
source venv/bin/activate

# Step 6: Install pip dependencies (with torch CPU for Pi-5)
log "Installing pip packages..."
pip install --upgrade pip
pip install torch --index-url https://download.pytorch.org/whl/cpu  # CPU-only for ARM64
pip install \
    python-dotenv \
    openai \
    passlib \
    pygit2 \
    requests \
    streamlit \
    pyyaml \
    beautifulsoup4 \
    black \
    chromadb \
    jsbeautifier \
    ntplib \
    numpy \
    sentence-transformers \
    sqlparse \
    tiktoken \
    || error "Pip install failed. Torch may need retry."

# Generate requirements.txt
pip freeze > requirements.txt
log "requirements.txt generated."

# Step 7: Project setup
log "Setting up project directories..."
mkdir -p prompts sandbox chroma_db
touch chatapp.db .env

# Create .env template
cat > .env << EOF
# Add your keys here
XAI_API_KEY=your_xai_key_here
LANGSEARCH_API_KEY=your_langsearch_key_here
EOF
warn "Edit .env with your API keys before running!"

# Step 8: Test install
log "Running quick test..."
source venv/bin/activate
python -c "import streamlit; print('Streamlit OK')" || warn "Streamlit import failed."
python -c "from sentence_transformers import SentenceTransformer; print('Embeddings OK')" || warn "Embeddings failed (first load slow)."
python -c "import chromadb; print('ChromaDB OK')" || warn "ChromaDB failed."
# PiSense quick test
libcamera-still -o test.jpg -t 100 && rm test.jpg && echo "Camera OK" || warn "Camera test failed - check wiring."
gpio -g write 18 1 && sleep 1 && gpio -g write 18 0 && echo "GPIO OK" || warn "GPIO test failed - check pigpiod."

# Step 9: Run script
log "Install complete! Run with: source venv/bin/activate && streamlit run Apex-Sentinel.py"
log "Activate venv: source venv/bin/activate"
log "Deactivate: deactivate"
log "Hardware: Wire LEDs to GPIO 18 (green)/19 (red), GND 6. Enable cam in raspi-config."

echo "=== Install finished. Check ${LOGFILE} for details. ==="
