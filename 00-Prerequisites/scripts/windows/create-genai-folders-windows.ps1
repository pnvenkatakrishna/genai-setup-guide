$ErrorActionPreference = "Stop"

# Create the workspace directly under C:\learningzone.
$root = "C:\learningzone"

$mainFolders = @("classbuild", "classcatchup", "classinsights")
$topics = @(
    "agentic-ai",
    "deep-agents",
    "llm-foundations",
    "llm-providers",
    "mcp",
    "python",
    "rag"
)

foreach ($folder in $mainFolders) {
    New-Item -ItemType Directory -Path (Join-Path $root $folder) -Force |
        Out-Null
}

foreach ($topic in $topics) {
    New-Item -ItemType Directory `
        -Path (Join-Path (Join-Path $root "classcatchup") $topic) `
        -Force | Out-Null
}

New-Item -ItemType Directory `
    -Path (Join-Path $root "classcatchup\llm-providers\claude-openai-agents") `
    -Force | Out-Null

Write-Host ""
Write-Host "GenAI workspace created successfully:" -ForegroundColor Green
Write-Host $root
Write-Host ""
Write-Host "Next, clone your private notes repository into classinsights"
Write-Host "and your public projects repository into classbuild."
