#!/bin/bash
# Test: Verify if the header dump script can handle the main Capture One binary using objdump and nm.

set -e

# Run the header dump script for the main binary only.
cd reconstructed_codebase
cp dump_headers.sh dump_headers_test.sh
sed -i '' '/# Frameworks/,$d' dump_headers_test.sh
chmod +x dump_headers_test.sh

./dump_headers_test.sh > /tmp/header_output.log 2>&1 || {
  echo "FAILURE: Header dump failed."
  cat /tmp/header_output.log
  exit 1
}

# Check if the output files are non-empty.
if [ ! -s "Headers/Main/Capture One_ObjC_Structure.txt" ]; then
  echo "FAILURE: ObjC structure dump file is empty."
  exit 1
fi

if [ ! -s "Headers/Main/Capture One_Symbols.txt" ]; then
  echo "FAILURE: Symbols dump file is empty."
  exit 1
fi

echo "SUCCESS: Header dump completed for main binary."
