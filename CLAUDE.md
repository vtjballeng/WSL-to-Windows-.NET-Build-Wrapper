# Claude Code Project Instructions

This project requires Windows Desktop components but can be built from WSL
using the provided build wrapper.

## Build Commands

Use the `build-wsl.sh` script for all build operations:

```bash
# Basic build
./build-wsl.sh build

# Clean and rebuild  
./build-wsl.sh rebuild

# Run tests
./build-wsl.sh test

# Release build
./build-wsl.sh release

# Verbose output for debugging
./build-wsl.sh verbose

# Quiet build
./build-wsl.sh quiet

# Clean only
./build-wsl.sh clean

# Restore packages
./build-wsl.sh restore
```

## Why This Approach?

- Project targets `net8.0-windows` which requires Windows Desktop runtime
- WSL .NET lacks Windows Desktop components
- The script bridges WSL to Windows .NET via `cmd.exe`
- Provides full build output visibility in Claude Code

## Build Requirements

- ✅ Windows .NET with Windows Desktop runtime
- ✅ All builds should complete with 0 errors
- ✅ Tests should pass (both Core and IO test projects)
- ⚠️ Some legacy package warnings are expected (WindowsAPICodePack)

## Recent Fixes Applied

- Fixed WPF binding errors (LoadConnectionsCommand/SaveConnectionsCommand)
- Fixed ArgumentNullException in TrackStatusResponseLoggingHelper
- Implemented dependency injection for better testability
- Fixed user-configured device naming logic

## Debugging

Always use the build wrapper for compilation errors - standard WSL
`dotnet build` will fail due to missing Windows Desktop components.

## Line Ending Management

**IMPORTANT - WSL/Windows Compatibility:**

This project requires careful line ending management due to Windows/WSL dual environment:

🔧 **Automatic Protection:**
- `.gitattributes` enforces LF line endings for shell scripts (*.sh, *.bash)
- Git configured with `core.autocrlf=false` and `core.safecrlf=warn`
- All shell scripts converted to LF endings for WSL compatibility

⚠️ **Common Issues Prevented:**
- `$'\r': command not found` errors in WSL
- `syntax error near unexpected token` in bash scripts
- Failed script execution due to CRLF line endings

📝 **Best Practices:**
- Shell scripts MUST use LF line endings for WSL execution
- Use `sed -i 's/\r$//' filename.sh` to fix CRLF issues
- Verify with `file filename.sh` (should not show "CRLF line terminators")
- Run `./validate-line-endings.sh` to check all scripts
- Use `./validate-line-endings.sh --fix` to auto-fix issues

✅ **Current Status:**
- All shell scripts verified with LF endings
- Git configuration prevents future line ending issues
- `.gitattributes` ensures consistent behavior across environments
