#!/bin/bash

# Declare associative arrays for firmware URLs and their destination directories
declare -A firmware_urls=(
    [mt7996]="https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/mediatek/mt7996/mt7996_dsp.bin
              https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/mediatek/mt7996/mt7996_eeprom.bin
              https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/mediatek/mt7996/mt7996_rom_patch.bin
              https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/mediatek/mt7996/mt7996_wa.bin
              https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/mediatek/mt7996/mt7996_wm.bin"
    [mt7986]="https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/mediatek/mt7986/mt7986_wo_1.bin
              https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/mediatek/mt7986/mt7986_wo_0.bin
              https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/mediatek/mt7986/mt7986_wm_mt7975.bin
              https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/mediatek/mt7986/mt7986_wm.bin
              https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/mediatek/mt7986/mt7986_wa.bin
              https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/mediatek/mt7986/mt7986_rom_patch_mt7975.bin
              https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/mediatek/mt7986/mt7986_rom_patch.bin
              https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/mediatek/mt7986/mt7986_eeprom_mt7976_dual.bin
              https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/mediatek/mt7986/mt7986_eeprom_mt7976_dbdc.bin
              https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/mediatek/mt7986/mt7986_eeprom_mt7976.bin
              https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/mediatek/mt7986/mt7986_eeprom_mt7975_dual.bin"
    [mt7981]="https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/mediatek/mt7981/mt7981_wo.bin
              https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/mediatek/mt7981/mt7981_wm.bin
              https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/mediatek/mt7981/mt7981_wa.bin
              https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/mediatek/mt7981/mt7981_rom_patch.bin"
    [mt7925]="https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/mediatek/mt7925/WIFI_MT7925_PATCH_MCU_1_1_hdr.bin
              https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/mediatek/mt7925/WIFI_RAM_CODE_MT7925_1_1.bin
              https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/mediatek/mt7925/BT_RAM_CODE_MT7925_1_1_hdr.bin"
    [mt7922]="https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/mediatek/WIFI_RAM_CODE_MT7922_1.bin
            https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/mediatek/WIFI_MT7922_patch_mcu_1_1_hdr.bin
            https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/mediatek/BT_RAM_CODE_MT7922_1_1_hdr.bin"  
    [mt7961]="https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/mediatek/WIFI_RAM_CODE_MT7961_1.bin
            https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/mediatek/WIFI_MT7961_patch_mcu_1_2_hdr.bin
            https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/mediatek/BT_RAM_CODE_MT7961_1_2_hdr.bin"  
    [mt7662]="https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/mediatek/mt7662u_rom_patch.bin
            https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/mediatek/mt7662u.bin
            https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/mediatek/mt7662_rom_patch.bin
            https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/mediatek/mt7662.bin"  
    [mt7610]="https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/mediatek/mt7610u.bin
            https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/mediatek/mt7610e.bin"
    [rtw88]="https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/tree/rtw88/rtw8723d_fw.bin
            https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/tree/rtw88/rtw8821c_fw.bin
            https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/tree/rtw88/rtw8822b_fw.bin
            https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/tree/rtw88/rtw8822c_fw.bin
            https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/tree/rtw88/rtw8822c_wow_fw.bin"
)

declare -A destination_dirs=(
    [mt7996]="/lib/firmware/mediatek/mt7996"
    [mt7986]="/lib/firmware/mediatek/mt7986"
    [mt7981]="/lib/firmware/mediatek/mt7981"
    [mt7925]="/lib/firmware/mediatek/mt7925"
    [mt7922]="/lib/firmware/mediatek"
    [mt7961]="/lib/firmware/mediatek"
    [mt7610]="/lib/firmware/mediatek"
    [rtw88]="/lib/firmware/rtw88"
)

# Function to download and copy firmware files for a given device
download_and_copy() {
    local device=$1
    local urls=(${firmware_urls[$device]})
    local destination_dir=${destination_dirs[$device]}
    
    # Ensure destination directory exists
    sudo mkdir -p "$destination_dir"
    
    # Download and copy each firmware file
    for url in "${urls[@]}"; do
        echo "Downloading: $url"
        wget "$url" -O "/tmp/$(basename "$url")"
        echo "Copying to $destination_dir"
        sudo cp "/tmp/$(basename "$url")" "$destination_dir"
    done

    echo "Firmware files for $device have been downloaded and copied successfully to $destination_dir."
}

# Iterate over the devices and process their firmware
for device in "${!firmware_urls[@]}"; do
    download_and_copy "$device"
done
