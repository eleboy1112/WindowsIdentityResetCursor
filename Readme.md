WindowsIdentityReset
A PowerShell script that resets and randomizes machine identifiers on Windows systems.
What It Does
This script performs the following operations:

Generates a random computer name using combinations of adjectives, nouns, and numbers
Creates a backup of current system identifiers before making changes
Changes machine identity by:

Setting a new random computer name
Generating and applying a new MachineGUID in the registry
Clearing cryptographic identifiers (CAPI)
Clearing Windows event logs (System, Application, Security)
Flushing DNS cache
Clearing browser caches (Chrome and Edge)
Resetting network settings (WinSock and IP)


Clears Cursor IDE data (if installed) with backup
Cleans temporary files from system and user temp folders
Offers to restart the computer to apply all changes

Why Use It
This script is useful for:

Enhancing privacy by resetting machine identifiers
Refreshing system identity after major changes
Preparing systems for redeployment
Troubleshooting identifier-related issues

Requirements

Must be run with administrator privileges
Windows operating system

The script includes error handling and creates backups of critical information before making changes.