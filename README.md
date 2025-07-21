# WSL to Windows .NET Build Wrapper

This repository provides build wrapper tools for developing Windows Desktop applications from WSL (Windows Subsystem for Linux). The wrapper solves the common issue where WSL's .NET runtime lacks Windows Desktop components required for WPF/WinForms applications.

## Overview

Windows Desktop applications targeting `net8.0-windows` require the Windows Desktop runtime, which is not available in WSL's .NET installation. This wrapper bridges WSL to Windows .NET via `cmd.exe`, allowing you to develop and build from your preferred Linux environment while using the full Windows .NET stack.

## Tools Included

### 1. build-wsl.sh - Main Build Wrapper

A comprehensive build wrapper that executes .NET commands through Windows cmd.exe while maintaining full output visibility in your WSL terminal.

#### Features
- **Cross-platform path handling**: Automatically converts WSL paths to Windows format
- **Full command coverage**: Supports all common .NET CLI operations
- **Output preservation**: Shows complete build output, warnings, and errors
- **Multiple build configurations**: Debug, Release, Verbose, Quiet modes
- **Test execution**: Runs test suites with proper Windows Desktop runtime

#### Configuration Required

**IMPORTANT**: Before first use, edit `build-wsl.sh` and change line 31:

```bash
# Change this line:
echo "Building ProjectName using Windows .NET from WSL..."

# To your actual project name:
echo "Building YourActualProjectName using Windows .NET from WSL..."
```

Replace `ProjectName` with your Visual Studio project or solution name for clearer output messages.

#### Usage

```bash
# Make script executable (first time only)
chmod +x build-wsl.sh

# Basic operations
./build-wsl.sh build      # Build the solution
./build-wsl.sh clean      # Clean build artifacts
./build-wsl.sh restore    # Restore NuGet packages
./build-wsl.sh rebuild    # Clean and rebuild

# Build variations
./build-wsl.sh verbose    # Build with detailed output
./build-wsl.sh quiet      # Build with minimal output
./build-wsl.sh release    # Build release configuration

# Testing
./build-wsl.sh test       # Run all tests

# Help
./build-wsl.sh           # Show usage information
```

#### How It Works

1. **Path Conversion**: Uses `wslpath -w` to convert WSL paths to Windows format
2. **Command Execution**: Executes commands via `cmd.exe /c` in the Windows environment
3. **Output Streaming**: Preserves all .NET CLI output, colors, and formatting
4. **Error Propagation**: Maintains exit codes for proper CI/CD integration

### 2. validate-line-endings.sh - Line Ending Manager

Ensures shell scripts have correct LF line endings for WSL compatibility. Windows text editors often introduce CRLF line endings that break bash script execution.

#### Common Issues Prevented
- `$'\r': command not found` errors
- `syntax error near unexpected token` in bash scripts
- Script execution failures due to Windows line endings

#### Usage

```bash
# Make script executable (first time only)
chmod +x validate-line-endings.sh

# Check line endings
./validate-line-endings.sh

# Check and fix automatically
./validate-line-endings.sh --fix
```

#### Sample Output

```bash
🔍 Checking line endings in shell scripts...
✅ LF line endings: ./build-wsl.sh
❌ CRLF line endings found in: ./other-script.sh
⚠️  Found 1 files with CRLF line endings.
💡 Run './validate-line-endings.sh --fix' to automatically convert them to LF.
```

## Quick Start

1. **Clone or download** these scripts to your project root
2. **Configure project name** in `build-wsl.sh` (line 31)
3. **Make scripts executable**:
   ```bash
   chmod +x build-wsl.sh validate-line-endings.sh
   ```
4. **Validate line endings**:
   ```bash
   ./validate-line-endings.sh --fix
   ```
5. **Build your project**:
   ```bash
   ./build-wsl.sh build
   ```

## Why This Approach?

### The Problem
```bash
# This fails in WSL for Windows Desktop apps:
dotnet build
# Error: Framework 'Microsoft.WindowsDesktop.App' is not available
```

### The Solution
```bash
# This works by using Windows .NET:
./build-wsl.sh build
# Successfully builds using Windows Desktop runtime
```

## Requirements

- **WSL 2** with .NET SDK installed
- **Windows** with .NET SDK including Windows Desktop runtime
- **Git configured** for cross-platform development:
  ```bash
  git config core.autocrlf false
  git config core.safecrlf warn
  ```

## Project Structure Support

The wrapper works with any .NET project structure:
- Single projects (`.csproj`)
- Solutions (`.sln`)
- Multi-project solutions
- Test projects
- Class libraries with Windows dependencies

## Troubleshooting

### Script Won't Execute
```bash
# Check line endings
./validate-line-endings.sh
# Fix if needed
./validate-line-endings.sh --fix
```

### Build Errors
```bash
# Use verbose output for debugging
./build-wsl.sh verbose
```

### Permission Issues
```bash
# Ensure scripts are executable
chmod +x *.sh
```

### Path Issues
The wrapper automatically handles path conversion, but if you encounter issues:
- Ensure you're running from the project root directory
- Check that Windows .NET is properly installed
- Verify WSL can access Windows drives

## Best Practices

1. **Always use the wrapper** for building Windows Desktop applications in WSL
2. **Validate line endings** before committing shell scripts
3. **Use verbose mode** when debugging build issues
4. **Keep scripts in project root** for easy access
5. **Commit `.gitattributes`** to enforce consistent line endings:
   ```
   *.sh text eol=lf
   *.bash text eol=lf
   ```

## Integration with Development Workflow

### VS Code
Add these tasks to `.vscode/tasks.json`:
```json
{
  "label": "Build (WSL)",
  "type": "shell",
  "command": "./build-wsl.sh",
  "args": ["build"],
  "group": "build"
}
```

### CI/CD
Use in GitHub Actions or other CI systems:
```yaml
- name: Build Windows Desktop App
  run: ./build-wsl.sh build
```

### Testing
```bash
# Run all tests
./build-wsl.sh test

# Check both build and line endings
./validate-line-endings.sh && ./build-wsl.sh test
```

This wrapper enables seamless Windows Desktop application development from WSL while maintaining the full .NET development experience.
