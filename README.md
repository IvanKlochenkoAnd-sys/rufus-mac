# 🚀 Rufus for macOS (`rufus-mac`)

[![Release](https://img.shields.io/badge/Release-Alpha_0.4-blueviolet?logo=github)](https://github.com/IvanKlochenkoAnd-sys/rufus-mac)
[![macOS](https://img.shields.io/badge/macOS-10.9_Mavericks_to_macOS_27_Golden_Gate-black?logo=apple)](https://apple.com)
[![Architecture](https://img.shields.io/badge/Architecture-Apple_Silicon_%26_Intel-blue)](https://apple.com)
[![Python](https://img.shields.io/badge/Python-3.7+-3776AB?logo=python&logoColor=white)](https://python.org)
[![Target OS](https://img.shields.io/badge/Target-Windows_11_%2F_10_%2F_8_%2F_7_%2F_XP_%2F_Linux-0078D6)](rufus-mac)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Zero Dependencies](https://img.shields.io/badge/Dependencies-Standard_Library_Only-success)](rufus-mac)

The definitive, battle-tested macOS alternative to [Rufus](https://rufus.ie/) that creates **genuine bootable USB flash drives** directly from macOS for **Windows (11, 10, 8.1, 8, 7, Vista, XP)**, **Linux Distributions (Ubuntu, Fedora, Debian, Arch, Mint)**, and **Raw Disk Images** (`.img`, `.raw`).

```
=================================================================
  RUFUS FOR MAC (macOS 27 Edition) - Alpha 0.4
  Universal Multi-OS & Multi-Windows Bootable USB Creator
=================================================================
[*] Scanning connected USB storage devices...

Select Target USB Drive:
  [1] DataTraveler 3.0 (57.7 GB) - /dev/disk17

Enter choice [1-1]: 1
[✓] Selected Target: DataTraveler 3.0 (/dev/disk17)
[✓] Detected OS Payload: Windows 11 Pro (x64) Build 26100 Setup
[*] UEFI Bootloader: Present (x64 Native EFI)
[*] Partition Scheme: GPT (UEFI Motherboard)
[*] Architecture: Universal Dual-Partition (FAT32 Boot + ExFAT Data)
[*] Injecting Windows 11 User Experience (WUE) bypasses...
[✓] BOOTABLE WINDOWS 11 USB SUCCESSFULLY CREATED!
```

---

## ⚡ Quick Start

### 1. Install `rufus-mac` globally

Run the one-line installer in Terminal:

```bash
curl -fsSL https://raw.githubusercontent.com/IvanKlochenkoAnd-sys/rufus-mac/main/install.sh | bash
```

*Or install from source:*

```bash
git clone https://github.com/IvanKlochenkoAnd-sys/rufus-mac.git
cd rufus-mac
./rufus-mac --install
```

### 2. Run anywhere

Once installed, simply run `rufus-mac` from any directory:

```bash
rufus-mac
```

---

## 🪟 Comprehensive Windows Support Matrix (Alpha 0.4)

Starting with **Alpha 0.4**, `rufus-mac` includes deep inspection of Windows WIM XML manifests and classic NT installer structures to automatically optimize partitioning, bootloaders, and customizations for all major Windows releases:

| Windows Version | Detection Method | Partition Schemes | Engine Architecture | Special Features |
| :--- | :--- | :--- | :--- | :--- |
| **Windows 11** (24H2, 23H2, 22H2, 21H2) | WIM Manifest (`build >= 22000`) | **GPT (UEFI)** *(Recommended)* or MBR | Universal Dual-Partition (FAT32 + ExFAT) | Full Rufus WUE Bypasses: TPM 2.0, Secure Boot, RAM, Storage, CPU, MS Account, BitLocker, `appraiserres.dll` patch |
| **Windows 10** (22H2 - 1507) | WIM Manifest (`10240 <= build < 22000`) | **GPT (UEFI)** or **MBR (BIOS)** | Dual-Partition or Single FAT32 | Online Account Bypass (`BypassNRO` / local account), BitLocker Auto-Encryption Disable |
| **Windows 8.1 & Windows 8** | WIM Manifest (`9200 <= build < 10240`) | **GPT (UEFI)** or **MBR (BIOS)** | Direct FAT32 (<4GB) or Dual-Partition | Native UEFI and Legacy BIOS / CSM boot support |
| **Windows 7** (SP1 & RTM) | WIM Manifest (`7600 <= build <= 7601`) | **MBR (BIOS)** *(Recommended)* or **GPT (UEFI)** | Direct FAT32 (<4GB) or Dual-Partition | **Automated Windows 7 x64 UEFI Bootloader Patch** (`bootx64.efi` generated from `cdboot.efi` / `bootmgfw.efi`) |
| **Windows Vista** (SP2, SP1, RTM) | WIM Manifest (`6000 <= build <= 6003`) | **MBR (BIOS / CSM)** | Direct FAT32 (<4GB) or Dual-Partition | Legacy BIOS Master Boot Record partitioning |
| **Windows XP & Server 2003** | Classic Layout (`I386` / `TXTSETUP.SIF` / `WIN51`) | **MBR (BIOS / CSM)** | Single MBR FAT32 Partition | Dedicated Windows NT 5.x classic setup engine |

### 🔧 Partition Scheme Flexibility: GPT (UEFI) vs MBR (BIOS)

Modern motherboards require **GPT (GUID Partition Table)** with UEFI, while older motherboards and vintage operating systems require **MBR (Master Boot Record)** with Legacy BIOS / CSM.

`rufus-mac` allows you to select the target partition scheme interactively in the wizard or via CLI flags:
- `--gpt` / `--uefi`: Enforces GUID Partition Table for UEFI boot.
- `--mbr` / `--bios`: Enforces Master Boot Record for Legacy BIOS / CSM boot.

### 🛡️ Windows 7 x64 UEFI Bootloader Patch

Official Windows 7 64-bit ISOs omit `/efi/boot/bootx64.efi` on the root of the install media, causing UEFI boots on modern PCs to fail. `rufus-mac` automatically detects Windows 7 x64 installations and injects the necessary UEFI bootloader payload (`bootx64.efi` derived from `cdboot.efi` or `bootmgfw.efi`), making Windows 7 bootable under 64-bit UEFI without third-party utilities!

---

## 🎯 The Problem `rufus-mac` Solves

Creating a bootable Windows installer from a Mac has historically been one of the most frustrating tasks in PC administration. Standard tools fail for very specific technical reasons:

| Tool / Method | What Happens | Why It Fails |
| :--- | :--- | :--- |
| **`dd` / BalenaEtcher** | ❌ **Unbootable** | Windows ISOs are not hybrid ISOs. Raw byte copy does not build an MBR/GPT partition map or UEFI filesystem. |
| **Simple FAT32 Copy** | ❌ **Crash / Error** | FAT32 has a hard **4GB single-file limit**. Modern Windows `install.wim` is ~5.5 GB to 8.5 GB and cannot be written to FAT32. |
| **Pure ExFAT / NTFS** | ❌ **Black Screen / No Boot** | UEFI Specification (Section 12.3.1) requires motherboards to boot from FAT32. 95%+ of PC BIOS ROMs have no ExFAT or NTFS driver. |
| **macOS `hdiutil` / Finder** | ❌ **"Image Corrupted"** | Modern macOS DiskImages framework fails to mount raw Microsoft UDF 2.01 optical media without low-level sector overrides. |

### The `rufus-mac` Solution: Universal Dual-Partition Architecture

`rufus-mac` implements the **Universal Dual-Partition Architecture**:

```
USB Drive (GPT or MBR Partition Map)
┌───────────────────────────────────────┬──────────────────────────────────────────────┐
│  Partition 1: WINBOOT (1.5 GB, FAT32) │  Partition 2: WININSTALL (Remaining, ExFAT)  │
│  - UEFI Bootloader (/efi/boot/)       │  - Full Windows Installation Image           │
│  - Windows Boot Manager (bootmgr.efi) │  - Full sources/install.wim (>8 GB)          │
│  - Windows PE Kernel (boot.wim)       │  - Complete setup payload                    │
│  - Auto-Unattend Answer File          │                                              │
└───────────────────────────────────────┴──────────────────────────────────────────────┘
```

1. **Motherboard Boot:** PC motherboard BIOS boots Partition 1 (`WINBOOT`) natively over standard FAT32.
2. **WinPE Environment:** Windows PE kernel (`boot.wim`) loads into system memory (RAM).
3. **Payload Discovery:** WinPE activates its built-in ExFAT driver and automatically mounts Partition 2 (`WININSTALL`) to install Windows without file splitting or loss of data integrity!

---

## 🐧 Multi-OS & Linux Flashing Engine

`rufus-mac` automatically identifies the operating system payload in your image and applies the optimal flashing engine:

| OS Family | Supported Formats | Engine Used | Features |
| :--- | :--- | :--- | :--- |
| **Windows 11 / 10 / 8 / 7** | `.iso` | Universal Dual-Partition (FAT32 + ExFAT) or Single FAT32 | UEFI GPT or Legacy MBR; Automatic WUE hardware & account bypasses |
| **Windows XP / 2003** | `.iso` | Dedicated Legacy MBR FAT32 Engine | Full classic NT 5.x installer replication |
| **Linux Live USB** | `.iso` (Hybrid) | High-Speed Native Block Stream (`/dev/rdisk`) | Ubuntu, Debian, Fedora, Arch Linux, Kali, Linux Mint, Manjaro, openSUSE |
| **Raw Disk Images** | `.img`, `.raw`, `.bin` | High-Speed Native Block Stream (`/dev/rdisk`) | Raspberry Pi OS, Armbian, Proxmox VE, TrueNAS, OpenWrt |

---

## 🛠️ Windows 11 User Experience (WUE) Bypasses

`rufus-mac` automatically generates and injects a custom `autounattend.xml` answer file that bypasses Microsoft's artificial hardware and account restrictions during installation:

- [x] **Bypass TPM 2.0 check** (`BypassTPMCheck`)
- [x] **Bypass Secure Boot check** (`BypassSecureBootCheck`)
- [x] **Bypass 4GB+ RAM check** (`BypassRAMCheck`)
- [x] **Bypass CPU Generation check** (`BypassCPUCheck`)
- [x] **Bypass Storage / Disk requirement check** (`BypassStorageCheck`)
- [x] **Bypass Online Microsoft Account requirement** (`BypassNRO` - install with a local offline account)
- [x] **Disable BitLocker Automatic Device Encryption** (`PreventDeviceEncryption`)
- [x] **Zero-byte compatibility appraiser patch** (`sources/appraiserres.dll`)

---

## 💻 Usage

### Interactive Wizard (Recommended)
Simply plug in your USB flash drive and launch:

```bash
rufus-mac
```

The wizard will:
1. Safely list all connected removable USB drives (strictly protecting internal Mac drives).
2. Auto-discover Windows ISOs in `~/Downloads`, `~/Desktop`, or `/Users/Shared`.
3. Auto-detect Windows version, edition, architecture, and build number.
4. Offer optimal partition scheme selection: GPT (UEFI) vs MBR (Legacy BIOS).
5. Let you toggle Windows bypasses tailored to your Windows version.
6. Provide a clear confirmation safeguard before formatting.

### Headless / Automation CLI Mode
Automate drive creation in scripts or CI:

```bash
# Automated Windows 11 creation with all hardware bypasses:
rufus-mac --iso "/Users/Shared/Win11_24H2_English_x64.iso" --target disk17 --bypass-all

# Windows 10 with offline account bypass and UEFI GPT:
rufus-mac --iso "~/Downloads/Win10_22H2_English_x64.iso" --target disk17 --gpt

# Windows 7 for Legacy BIOS / CSM PC:
rufus-mac --iso "~/Downloads/Win7_SP1_x64.iso" --target disk17 --mbr

# Windows 7 with automated 64-bit UEFI Bootloader Patch:
rufus-mac --iso "~/Downloads/Win7_SP1_x64.iso" --target disk17 --gpt

# Windows XP / Server 2003 Classic MBR installation:
rufus-mac --iso "~/Downloads/WinXP_SP3.iso" --target disk17

# High-speed Linux live USB creation (Ubuntu, Fedora, Arch, etc.):
rufus-mac --image "~/Downloads/ubuntu-24.04-desktop-amd64.iso" --target disk17

# Raw image flashing (Raspberry Pi OS, Proxmox, TrueNAS, etc.):
rufus-mac --image "~/Downloads/raspios-arm64.img" --target disk17

# List safe external USB disks:
rufus-mac --list-disks

# Force raw DD block writing mode:
rufus-mac --image "debian-live.iso" --target disk17 --raw
```

---

## 🖥️ Compatibility

`rufus-mac` is written in clean, dependency-free Python 3 using standard macOS system primitives. It works out of the box with zero third-party packages required:

| macOS Version | Codename | Architectures | Status |
| :--- | :--- | :--- | :--- |
| **macOS 27** | Golden Gate | Apple Silicon | ✅ Fully Supported |
| **macOS 26** | Tahoe | Apple Silicon / Intel | ✅ Fully Supported |
| **macOS 15** | Sequoia | Apple Silicon / Intel | ✅ Fully Supported |
| **macOS 14** | Sonoma | Apple Silicon / Intel | ✅ Fully Supported |
| **macOS 13** | Ventura | Apple Silicon / Intel | ✅ Fully Supported |
| **macOS 12** | Monterey | Apple Silicon / Intel | ✅ Fully Supported |
| **macOS 11** | Big Sur | Apple Silicon / Intel | ✅ Fully Supported |
| **macOS 10.15** | Catalina | Intel | ✅ Fully Supported |
| **macOS 10.14** | Mojave | Intel | ✅ Fully Supported |
| **macOS 10.13** | High Sierra | Intel | ✅ Fully Supported |
| **macOS 10.12** | Sierra | Intel | ✅ Fully Supported |
| **OS X 10.11** | El Capitan | Intel | ✅ Fully Supported |
| **OS X 10.10** | Yosemite | Intel | ✅ Fully Supported |
| **OS X 10.9** | Mavericks | Intel | ✅ Fully Supported |

---

## 🔒 Safety First

`rufus-mac` implements strict hardware sanity checks to guarantee data safety:
- **Never touches internal disks:** Built-in APFS containers, Apple Fabric, and internal drives (`disk0`, `disk1`, `Macintosh HD`) are completely filtered out and protected.
- **Physical removable check:** Only genuine external USB / Thunderbolt removable mass storage devices (8 GB or larger) can ever be selected.
- **Explicit confirmation:** Interactive mode requires an explicit `YES` prompt before any partitioning begins.

---

## ⌨️ PC Motherboard Boot Keys Cheat Sheet

Once your USB drive is created, plug it into your target PC and tap your boot menu key during power-on:

| Motherboard / Manufacturer | Boot Menu Key | BIOS / UEFI Key |
| :--- | :--- | :--- |
| **ASUS** | <kbd>F8</kbd> | <kbd>Del</kbd> or <kbd>F2</kbd> |
| **MSI** | <kbd>F11</kbd> | <kbd>Del</kbd> |
| **Gigabyte / AORUS** | <kbd>F12</kbd> | <kbd>Del</kbd> |
| **ASRock** | <kbd>F11</kbd> | <kbd>Del</kbd> or <kbd>F2</kbd> |
| **Dell / Alienware** | <kbd>F12</kbd> | <kbd>F2</kbd> |
| **HP / OMEN** | <kbd>F9</kbd> or <kbd>Esc</kbd> | <kbd>F10</kbd> |
| **Lenovo / Legion** | <kbd>F12</kbd> or Novo Button | <kbd>F2</kbd> or <kbd>Fn+F2</kbd> |

Select `UEFI: <Your USB Drive Name>` from the boot menu to begin installation.

---

## 📄 License

Distributed under the **MIT License**. See [`LICENSE`](LICENSE) for details.
Windows is a registered trademark of Microsoft Corporation. This project is an independent open-source tool inspired by the original Rufus utility for Windows by Pete Batard.
