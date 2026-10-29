#!/usr/bin/env bash
# ==============================================================================
#  Rufus for macOS (rufus-mac) - One-Line Installer
#  Compatible with macOS 10.15 Catalina through macOS 27 Golden Gate
# ==============================================================================

set -e

REPO_URL="https://raw.githubusercontent.com/ivanklochenko/rufus-mac/main/rufus-mac"
INSTALL_DIR="/usr/local/bin"
TARGET_BIN="${INSTALL_DIR}/rufus-mac"

BOLD="\033[1m"
CYAN="\033[96m"
GREEN="\033[92m"
YELLOW="\033[93m"
RESET="\033[0m"

echo -e "\n${BOLD}${CYAN}=================================================================${RESET}"
echo -e "${BOLD}${CYAN}  Rufus for macOS - Reliable Windows 11 USB Creator Installer    ${RESET}"
echo -e "${BOLD}${CYAN}=================================================================${RESET}\n"

# Verify macOS environment
if [[ "$(uname -s)" != "Darwin" ]]; then
    echo -e "${YELLOW}Error: Rufus for macOS is designed exclusively for macOS.${RESET}"
    exit 1
fi

# Verify Python 3
if ! command -v python3 &>/dev/null; then
    echo -e "${YELLOW}Error: Python 3 is required. Please install Xcode Command Line Tools:${RESET}"
    echo "  xcode-select --install"
    exit 1
fi

# Check if installing from local repo or remote curl
if [[ -f "./rufus-mac" ]]; then
    echo -e "[*] Installing from local repository..."
    if [[ -w "${INSTALL_DIR}" ]]; then
        cp -f "./rufus-mac" "${TARGET_BIN}"
        chmod +x "${TARGET_BIN}"
    else
        echo -e "[*] Requesting administrator permission to install to ${INSTALL_DIR}..."
        sudo cp -f "./rufus-mac" "${TARGET_BIN}"
        sudo chmod +x "${TARGET_BIN}"
    fi
else
    echo -e "[*] Downloading latest rufus-mac from GitHub..."
    TMP_FILE="$(mktemp /tmp/rufus-mac.XXXXXX)"
    curl -fsSL "${REPO_URL}" -o "${TMP_FILE}"
    chmod +x "${TMP_FILE}"

    if [[ -w "${INSTALL_DIR}" ]]; then
        mv "${TMP_FILE}" "${TARGET_BIN}"
    else
        echo -e "[*] Requesting administrator permission to install to ${INSTALL_DIR}..."
        sudo mv "${TMP_FILE}" "${TARGET_BIN}"
    fi
fi

# Also create symlink in user bin if ~/.local/bin exists in PATH
if [[ ":$PATH:" == *":$HOME/.local/bin:"* ]]; then
    mkdir -p "$HOME/.local/bin"
    ln -sf "${TARGET_BIN}" "$HOME/.local/bin/rufus-mac"
fi

echo -e "\n${GREEN}[✓] Installation successful!${RESET}"
echo -e "You can now run ${BOLD}${CYAN}rufus-mac${RESET} directly from any terminal!\n"
echo -e "Try it now:"
echo -e "  ${CYAN}rufus-mac --help${RESET}"
echo -e "  ${CYAN}rufus-mac --list-disks${RESET}\n"
