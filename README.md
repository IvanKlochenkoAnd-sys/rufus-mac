# 🚀 Rufus for macOS (`rufus-mac`)

[![macOS](https://img.shields.io/badge/macOS-10.15_Catalina_to_macOS_27_Golden_Gate-black?logo=apple)](https://apple.com)
[![Architecture](https://img.shields.io/badge/Architecture-Apple_Silicon_%26_Intel-blue)](https://apple.com)
[![Python](https://img.shields.io/badge/Python-3.7+-3776AB?logo=python&logoColor=white)](https://python.org)
[![Windows 11](https://img.shields.io/badge/Target-Windows_11_24H2_%2F_23H2_%2F_10-0078D6?logo=windows&logoColor=white)](https://microsoft.com)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Zero Dependencies](https://img.shields.io/badge/Dependencies-Standard_Library_Only-success)](rufus-mac)

The definitive, battle-tested macOS alternative to [Rufus](https://rufus.ie/) that creates **genuine, 100% bootable Windows 11 installation USB flash drives** directly from macOS for modern UEFI PCs.

```
=================================================================
  RUFUS FOR MAC (rufus-mac)
  Reliable, Bootable Windows 11 USB Creator for Mac
=================================================================
[*] Scanning connected USB storage devices...

Select Target USB Drive:
  [1] DataTraveler 3.0 (57.7 GB) - /dev/disk17

Enter choice [1-1]: 1
[✓] Selected Target: DataTraveler 3.0 (/dev/disk17)
[✓] ISO mounted at: /Volumes/CCCOMA_X64FRE_EN-US_DV9
[✓] Valid Windows 11 image verified (UEFI Bootloader: Present, install.wim: 7.6 GB)
[*] Partitioning USB: Universal Dual-Partition GPT (FAT32 Boot + ExFAT Data)...
[*] Transferring Windows 11 setup payload...
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

## 🎯 The Problem `rufus-mac` Solves

Creating a bootable Windows 11 installer from a Mac has historically been one of the most frustrating tasks in PC administration. Standard tools fail for very specific technical reasons:

| Tool / Method | What Happens | Why It Fails |
| :--- | :--- | :--- |
| **`dd` / BalenaEtcher** | ❌ **Unbootable** | Windows ISOs are not hybrid ISOs. Raw byte copy does not build an MBR/GPT partition map or UEFI filesystem. |
| **Simple FAT32 Copy** | ❌ **Crash / Error** | FAT32 has a hard **4GB single-file limit**. Windows 11 `install.wim` is ~5.5 GB to 8.5 GB and cannot be written to FAT32. |
| **Pure ExFAT / NTFS** | ❌ **Black Screen / No Boot** | UEFI Specification (Section 12.3.1) requires motherboards to boot from FAT32. 95%+ of PC BIOS ROMs have no ExFAT or NTFS driver. |
| **macOS `hdiutil` / Finder** | ❌ **"Image Corrupted"** | Modern macOS DiskImages framework fails to mount raw Microsoft UDF 2.01 optical media without low-level sector overrides. |

### The `rufus-mac` Solution: Universal Dual-Partition GPT

`rufus-mac` implements the **Universal Dual-Partition Architecture**:

```
USB Drive (GPT Partition Map)
┌───────────────────────────────────────┬──────────────────────────────────────────────┐
│  Partition 1: WINBOOT (1.5 GB, FAT32) │  Partition 2: WININSTALL (Remaining, ExFAT)  │
│  - UEFI Bootloader (/efi/boot/)       │  - Full Windows 11 Installation Image        │
│  - Windows Boot Manager (bootmgr.efi) │  - Full sources/install.wim (>8 GB)          │
│  - Windows PE Kernel (boot.wim)       │  - Complete setup payload                    │
│  - Auto-Unattend Answer File          │                                              │
└───────────────────────────────────────┴──────────────────────────────────────────────┘
```

1. **UEFI Boot:** PC motherboard BIOS boots Partition 1 (`WINBOOT`) natively over standard FAT32.
2. **WinPE Environment:** Windows PE kernel (`boot.wim`) loads into system memory (RAM).
3. **Payload Discovery:** WinPE activates its built-in ExFAT driver and automatically mounts Partition 2 (`WININSTALL`) to install Windows 11 without file splitting or loss of data integrity!

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
3. Auto-detect already mounted Windows volumes in `/Volumes`.
4. Let you toggle Windows 11 bypasses.
5. Provide a clear confirmation safeguard before formatting.

### Headless / Automation CLI Mode
Automate drive creation in scripts or CI:

```bash
# Full automated Windows 11 USB creation with all bypasses:
rufus-mac --iso "/Users/Shared/Win11_24H2_English_x64.iso" --target disk17 --bypass-all

# Safe disk discovery:
rufus-mac --list-disks

# Single FAT32 mode with split WIM (requires wimlib):
rufus-mac --iso "/path/to/windows.iso" --target disk17 --single-fat32
```

---

## 🖥️ Compatibility

`rufus-mac` is written in clean, dependency-free Python 3 using standard macOS system primitives. It works out of the box with zero third-party packages required:

| macOS Version | Codename | Architectures | Status |
| :--- | :--- | :--- | :--- |
| **macOS 27** | Golden Gate | Apple Silicon / Intel | ✅ Fully Supported |
| **macOS 26** | — | Apple Silicon / Intel | ✅ Fully Supported |
| **macOS 15** | Sequoia | Apple Silicon / Intel | ✅ Fully Supported |
| **macOS 14** | Sonoma | Apple Silicon / Intel | ✅ Fully Supported |
| **macOS 13** | Ventura | Apple Silicon / Intel | ✅ Fully Supported |
| **macOS 12** | Monterey | Apple Silicon / Intel | ✅ Fully Supported |
| **macOS 11** | Big Sur | Apple Silicon / Intel | ✅ Fully Supported |
| **macOS 10.15** | Catalina | Intel | ✅ Fully Supported |

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
