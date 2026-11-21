
$ErrorActionPreference = "Stop"

# --------------------------------------------------
# GenAI Learning Workspace Setup
# Compatible with Windows PowerShell 5.1
# --------------------------------------------------

# Create learningzone in the current working directory
$parent = (Get-Location).Path
$root = Join-Path $parent "learningzone"

# Main folders
$mainFolders = @(
    "classbuild",
    "classcatchup",
    "classinsights"
)

# Topic folders
$topics = @(
    "agentic-ai",
    "deep-agents",
    "llm-foundations",
    "llm-providers",
    "mcp",
    "python",
    "rag"
)

# Nested topic folder
$nestedFolder = "claude-openai-agents"

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "   GENAI LEARNING WORKSPACE SETUP" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

Write-Host ""
Write-Host "Creating workspace at: $root" -ForegroundColor Yellow

# Create learningzone root
New-Item -ItemType Directory -Path $root -Force |
    Out-Null

# Create main folders
foreach ($folder in $mainFolders) {

    $mainPath = Join-Path $root $folder

    New-Item -ItemType Directory -Path $mainPath -Force |
        Out-Null

    # Create all topic folders inside each main folder
    foreach ($topic in $topics) {

        $topicPath = Join-Path $mainPath $topic

        New-Item -ItemType Directory -Path $topicPath -Force |
            Out-Null
    }

    # Create nested folder inside llm-providers
    $nestedPath = Join-Path $mainPath "llm-providers\$nestedFolder"

    New-Item -ItemType Directory -Path $nestedPath -Force |
        Out-Null
}

# Success message
Write-Host ""
Write-Host "==========================================" -ForegroundColor Green
Write-Host "   WORKSPACE CREATED SUCCESSFULLY!" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green

Write-Host ""
Write-Host "Workspace: $root" -ForegroundColor Cyan

Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Clone your public GitHub repository into classbuild."
Write-Host "2. Clone your private GitHub repository into classinsights."
Write-Host "3. Keep classcatchup for class recordings."

Write-Host ""
Write-Host "Open workspace in VS Code using:"
Write-Host "code `"$root`"" -ForegroundColor Cyan

Write-Host ""
