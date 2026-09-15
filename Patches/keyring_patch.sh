#!/bin/bash
# Description: KernelSU Pre-4.10 Init Keyring patch converted to sed script

TARGET_DIR="${1:-.}"

echo "[+] Searching for KernelSU compatibility files in: $TARGET_DIR"

COMPAT_C=$(find "$TARGET_DIR" -type f -path "*/kernel_compat.c" | head -n 1)
COMPAT_H=$(find "$TARGET_DIR" -type f -path "*/kernel_compat.h" | head -n 1)

if [ -z "$COMPAT_C" ] && [ -z "$COMPAT_H" ]; then
    echo "[-] KernelSU compat files not found in $TARGET_DIR!"
    exit 1
fi

apply_keyring_sed() {
    local file="$1"
    if [ -f "$file" ]; then
        echo "[+] Patching keyring bounds in: $file"
        
        # Replace Linux version checks for init_keyring (4.10.0 -> 4.15.0)
        sed -i 's/LINUX_VERSION_CODE < KERNEL_VERSION(4, 10, 0)/LINUX_VERSION_CODE < KERNEL_VERSION(4, 15, 0)/g' "$file"
        sed -i 's/LINUX_VERSION_CODE >= KERNEL_VERSION(4, 10, 0)/LINUX_VERSION_CODE >= KERNEL_VERSION(4, 15, 0)/g' "$file"

        # Verify replacement
        if grep -q "4, 15, 0" "$file"; then
            echo "[+] Successfully patched $file"
        else
            echo "[!] Warning: Pattern '4, 10, 0' not found or already patched in $file"
        fi
    fi
}

apply_keyring_sed "$COMPAT_C"
apply_keyring_sed "$COMPAT_H"

echo "[+] Keyring patch script finished."
