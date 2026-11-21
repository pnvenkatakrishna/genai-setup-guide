#!/usr/bin/env bash
set -eu

# Run this script from the parent directory where learningzone should be created.
root="learningzone"

main_folders=("classbuild" "classcatchup" "classinsights")
topics=(
  "agentic-ai"
  "deep-agents"
  "llm-foundations"
  "llm-providers"
  "mcp"
  "python"
  "rag"
)

for folder in "${main_folders[@]}"; do
  mkdir -p "$root/$folder"
done

for topic in "${topics[@]}"; do
  mkdir -p "$root/classcatchup/$topic"
done

mkdir -p "$root/classcatchup/llm-providers/claude-openai-agents"

printf "\nGenAI workspace created successfully:\n%s/%s\n\n" "$PWD" "$root"
printf "Next, clone your private notes repository into classinsights\n"
printf "and your public projects repository into classbuild.\n"
