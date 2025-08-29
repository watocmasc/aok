#!/bin/bash

echo "=== Dependency Check for AOK ==="
echo ""

echo "1. Qt6 Libraries:"
ldd /opt/aok/aok | grep Qt6
echo ""

echo "2. Gumbo Library:"
ldd /opt/aok/aok | grep gumbo
echo ""

echo "3. System Qt6 Version:"
qmake6 --version 2>/dev/null || echo "qmake6 not found"
echo ""

echo "4. Available Qt6 Libraries:"
ls -la /usr/lib/x86_64-linux-gnu/libQt6* 2>/dev/null | head -10
echo ""

echo "5. Available Gumbo Libraries:"
find /usr -name "libgumbo*" 2>/dev/null
echo ""

echo "6. Library Path:"
echo $LD_LIBRARY_PATH
echo ""

echo "7. ldconfig Cache:"
ldconfig -p | grep -E "(Qt6|gumbo)" | head -10