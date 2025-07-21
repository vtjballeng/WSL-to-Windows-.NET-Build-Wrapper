#!/bin/bash
# Line Ending Validation Script
# Checks and optionally fixes CRLF line endings in shell scripts

set -e

echo "🔍 Checking line endings in shell scripts..."

# Find all shell scripts
shell_scripts=$(find . -name "*.sh" -o -name "*.bash" | grep -v ".git")

issues_found=0
fixed_files=0

for script in $shell_scripts; do
    if file "$script" | grep -q "CRLF"; then
        echo "❌ CRLF line endings found in: $script"
        issues_found=$((issues_found + 1))
        
        if [ "$1" = "--fix" ]; then
            echo "🔧 Converting $script to LF line endings..."
            sed -i 's/\r$//' "$script"
            fixed_files=$((fixed_files + 1))
            echo "✅ Fixed: $script"
        fi
    else
        echo "✅ LF line endings: $script"
    fi
done

if [ $issues_found -eq 0 ]; then
    echo "🎉 All shell scripts have correct LF line endings!"
    exit 0
elif [ "$1" = "--fix" ]; then
    echo "🎉 Fixed $fixed_files files with CRLF line endings!"
    exit 0
else
    echo "⚠️  Found $issues_found files with CRLF line endings."
    echo "💡 Run '$0 --fix' to automatically convert them to LF."
    exit 1
fi