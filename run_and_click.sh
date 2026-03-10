#!/bin/bash
echo "Building..."
cd src && swift build -c debug --product CaptureOneApp
echo "Running..."
./.build/arm64-apple-macosx/debug/CaptureOneApp
