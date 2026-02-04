# Windows Setup Script for Claude Code Orchestra
# Run this script to initialize a new project from the Claude Code Orchestra template.

$repoUrl = "https://github.com/nyattoh/claude-code-orchestra-win.git"
$tempDir = ".starter"

Write-Host "Initializing Claude Code Orchestra project on Windows..." -ForegroundColor Cyan

# Check if git is installed
if (-not (Get-Command "git" -ErrorAction SilentlyContinue)) {
    Write-Error "Git is not installed. Please install Git for Windows."
    exit 1
}

# Clone the repository
Write-Host "Cloning template from $repoUrl..."
git clone --depth 1 $repoUrl $tempDir
if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to clone repository."
    exit 1
}

# Copy configuration files
Write-Host "Copying configuration files..."
$itemsToCopy = @(".claude", ".codex", ".gemini", "CLAUDE.md")

foreach ($item in $itemsToCopy) {
    $source = Join-Path $tempDir $item
    if (Test-Path $source) {
        Copy-Item -Path $source -Destination ".\" -Recurse -Force
        Write-Host "Copied $item"
    }
    else {
        Write-Warning "Source $item not found in template."
    }
}

# Clean up
Write-Host "Cleaning up temporary files..."
Remove-Item -Path $tempDir -Recurse -Force

Write-Host "Setup complete!" -ForegroundColor Green

if (Get-Command "claude" -ErrorAction SilentlyContinue) {
    Write-Host "Starting Claude..."
    claude
}
else {
    Write-Warning "Claude Code CLI not found."
    Write-Host "Please install it with: npm install -g @anthropic-ai/claude-code"
    Write-Host "Then run: claude login"
    Write-Host "Finally run: claude"
}
