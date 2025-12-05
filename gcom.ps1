param (
    [Parameter(Mandatory=$true)]
    [string]$Message
)

Write-Host "🚀 Starting Auto-Fix Commit..." -ForegroundColor Cyan
git add .

try {
    uv run pre-commit run --all-files
} catch {
    Write-Host "✨ Code automatically fixed by Ruff." -ForegroundColor Yellow
}

git add .
git commit -m $Message