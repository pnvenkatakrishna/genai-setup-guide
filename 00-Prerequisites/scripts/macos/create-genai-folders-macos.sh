
#!/bin/bash

set -e

# --------------------------------------------------
# GenAI Learning Workspace Setup
# Compatible with macOS
# --------------------------------------------------

# Create learningzone in the current working directory
parent="$(pwd)"
root="$parent/learningzone"

# Main folders
main_folders=(
    "classbuild"
    "classcatchup"
    "classinsights"
)

# Topic folders
topics=(
    "agentic-ai"
    "deep-agents"
    "llm-foundations"
    "llm-providers"
    "mcp"
    "python"
    "rag"
)

# Nested topic folder
nested_folder="claude-openai-agents"

echo ""
echo "=========================================="
echo "   GENAI LEARNING WORKSPACE SETUP"
echo "=========================================="

echo ""
echo "Creating workspace at: $root"

# Create learningzone root
mkdir -p "$root"

# Create main folders and topic folders
for folder in "${main_folders[@]}"; do

    main_path="$root/$folder"

    mkdir -p "$main_path"

    # Create all topic folders inside each main folder
    for topic in "${topics[@]}"; do

        topic_path="$main_path/$topic"

        mkdir -p "$topic_path"

    done

    # Create nested folder inside llm-providers
    nested_path="$main_path/llm-providers/$nested_folder"

    mkdir -p "$nested_path"

done

# Success message
echo ""
echo "=========================================="
echo "   WORKSPACE CREATED SUCCESSFULLY!"
echo "=========================================="

echo ""
echo "Workspace: $root"

echo ""
echo "Next steps:"
echo "1. Clone your public GitHub repository into classbuild."
echo "2. Clone your private GitHub repository into classinsights."
echo "3. Keep classcatchup for class recordings."

echo ""
echo "Open workspace in VS Code using:"
echo "code \"$root\""

echo ""
