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

# Frameworks
for fwk in "$APP_DIR/Contents/Frameworks/"*.framework; do
    fwk_name=$(basename "$fwk" .framework)
    # Binary is often at Versions/A/<Name> or just <Name>
    if [ -f "$fwk/Versions/A/$fwk_name" ]; then
        dump_source "$fwk/Versions/A/$fwk_name" "Source/Frameworks/$fwk_name"
    elif [ -f "$fwk/$fwk_name" ]; then
        dump_source "$fwk/$fwk_name" "Source/Frameworks/$fwk_name"
    fi
done

# Plugins
for plugin in "$APP_DIR/Contents/PlugIns/"*.bundle; do
    plugin_name=$(basename "$plugin" .bundle)
    if [ -f "$plugin/Contents/MacOS/$plugin_name" ]; then
        dump_source "$plugin/Contents/MacOS/$plugin_name" "Source/PlugIns/$plugin_name"
    fi
done
for plugin in "$APP_DIR/Contents/PlugIns/"*.coplugin; do
    plugin_name=$(basename "$plugin" .coplugin)
    if [ -f "$plugin/Contents/MacOS/$plugin_name" ]; then
        dump_source "$plugin/Contents/MacOS/$plugin_name" "Source/PlugIns/$plugin_name"
    fi
done

# XPCServices
for xpc in "$APP_DIR/Contents/XPCServices/"*.xpc; do
    xpc_name=$(basename "$xpc" .xpc)
    if [ -f "$xpc/Contents/MacOS/$xpc_name" ]; then
        dump_source "$xpc/Contents/MacOS/$xpc_name" "Source/XPCServices/$xpc_name"
    fi
done
