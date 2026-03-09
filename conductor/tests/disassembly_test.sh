#!/bin/bash
# Test: Verify if the disassembly script can handle the main Capture One binary using objdump.

set -e

# Run the disassembly script for the main binary only.
# Temporarily modify dump_source.sh to exit after disassembling the main binary for testing.
cd src
cp dump_source.sh dump_source_test.sh
sed -i '' '/# Frameworks/,$d' dump_source_test.sh
chmod +x dump_source_test.sh

./dump_source_test.sh > /tmp/disassembly_output.log 2>&1 || {
  echo "FAILURE: Disassembly failed."
  cat /tmp/disassembly_output.log
  exit 1
}

# Check if the output file is non-empty.
if [ ! -s "Source/Main/Capture One_Disassembly.S" ]; then
  echo "FAILURE: Disassembly output file is empty."
  exit 1
fi

echo "SUCCESS: Disassembly completed for main binary."
