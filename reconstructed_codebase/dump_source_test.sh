#!/bin/bash
APP_DIR="../Capture One.app"
ARCH="arm64"
OBJDUMP="objdump"

dump_source() {
    local bin_path="$1"
    local output_dir="$2"
    local base_name=$(basename "$bin_path")
    
    echo "Disassembling $base_name ($ARCH)..."
    mkdir -p "$output_dir"
    
    # Use objdump with --macho and --arch-name for faster and more reliable disassembly on macOS.
    $OBJDUMP -d --macho --arch-name=$ARCH "$bin_path" > "$output_dir/${base_name}_Disassembly.S" 2> /tmp/objdump_error.log
    
    if [ $? -ne 0 ]; then
        echo "Error disassembling $base_name. See /tmp/objdump_error.log"
        cat /tmp/objdump_error.log
    else
        # Verify if the output file is non-empty.
        if [ ! -s "$output_dir/${base_name}_Disassembly.S" ]; then
            echo "Warning: $base_name produced empty disassembly."
        fi
    fi
}

# Main executable
dump_source "$APP_DIR/Contents/MacOS/Capture One" "Source/Main"

