# WindowsIdentityReset

A PowerShell script that resets and randomizes machine identifiers on Windows systems.

## 🔍 What It Does

This script performs the following operations:

- **Randomizes Computer Identity:**
  - Generates a new random computer name using combinations of adjectives, nouns, and numbers
  - Creates a backup of current system identifiers before making any changes

- **Changes Machine Identifiers:**
  - Sets the newly generated random computer name
  - Generates and applies a new MachineGUID in the registry
  - Clears cryptographic identifiers (CAPI)
  - Clears Windows event logs (System, Application, Security)
  - Flushes DNS cache
  - Clears browser caches (Chrome and Edge)
  - Resets network settings (WinSock and IP)

- **Performs Additional Cleanup:**
  - Clears Cursor IDE data (if installed) with automatic backup
  - Cleans temporary files from system and user temp folders
  - Offers to restart the computer to apply all changes

## 🛠️ Why Use It

This script is useful for:

- Enhancing privacy by resetting machine identifiers
- Refreshing system identity after major changes
- Preparing systems for redeployment
- Troubleshooting identifier-related issues

## ⚙️ Requirements

- Must be run with administrator privileges
- Windows operating system

## ⚠️ Important Notes

The script includes error handling and creates backups of critical information before making changes.

## 🚀 Usage

1. Run PowerShell as Administrator
2. Set execution policy to allow script: `Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process`
3. Navigate to script directory
4. Run the script: `.\reset_machine.ps1`
5. Follow the on-screen prompts

## 🔄 What Gets Reset

| Category | Items |
|----------|-------|
| System Identifiers | Computer name, MachineGUID |
| Network | DNS cache, WinSock catalog, IP configuration |
| Logs | Windows event logs (System, Application, Security) |
| Caches | Browser caches, cryptographic containers |
| Temporary Files | System and user temp directories | 
