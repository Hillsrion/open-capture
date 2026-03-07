#!/bin/bash
APP_DIR="../Capture One.app"
ARCH="arm64"
OBJDUMP="objdump"

dump_binary() {
    local bin_path="$1"
    local output_dir="$2"
    local base_name=$(basename "$bin_path")
    
    echo "Dumping $base_name ($ARCH) using objdump and nm..."
    mkdir -p "$output_dir"
    
    # Use objdump --objc-meta-data for reliable structural metadata (works better than dsdump/otool on modern binaries)
    $OBJDUMP --macho --objc-meta-data --arch-name=$ARCH "$bin_path" > "$output_dir/${base_name}_ObjC_Structure.txt" 2> /tmp/objdump_header_error.log
    
    # Dump all symbols
    nm -m -arch $ARCH "$bin_path" > "$output_dir/${base_name}_Symbols.txt" 2>/dev/null
    
    # Swift symbols (demangled)
    nm -m -arch $ARCH "$bin_path" | swift demangle > "$output_dir/${base_name}_Swift_Symbols.txt" 2>/dev/null
}

# Main executable
dump_binary "$APP_DIR/Contents/MacOS/Capture One" "Headers/Main"

