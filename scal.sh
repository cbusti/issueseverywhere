#!/bin/bash

# Root project folder
ROOT="/c/925"
REPO="issueseverywhere"
OWNER="cbusti"
BRANCH="master"

# Create nested folders
NESTED="level1/level2/level3/level4/level5"
mkdir -p "$ROOT/$NESTED"

# Create folder.txt in each level
IFS='/' read -ra LEVELS <<< "$NESTED"
current="$ROOT"
for level in "${LEVELS[@]}"; do
  current="$current/$level"
  mkdir -p "$current"
  echo "$level" > "$current/folder.txt"
done

# Create GitHub Actions workflow
mkdir -p "$ROOT/.github/workflows"
cat > "$ROOT/.github/workflows/cat-files.yml" <<EOF
name: Show Folder Contents

on:
  push:
    branches: [ $BRANCH ]

jobs:
  show-files:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repo
        uses: actions/checkout@v3

      - name: Traverse folders and display contents
        run: |
          echo "📁 Starting from root..."
          cd level1
          echo "📁 Entered level1"
          cat folder.txt
          echo ""

          cd level2
          echo "📁 Entered level2"
          cat folder.txt
          echo ""

          cd level3
          echo "📁 Entered level3"
          cat folder.txt
          echo ""

          cd level4
          echo "📁 Entered level4"
          cat folder.txt
          echo ""

          cd level5
          echo "📁 Entered level5"
          cat folder.txt
          echo ""
EOF

# Create .gitignore with smart exclusions
cat > "$ROOT/.gitignore" <<EOF
# System files
*.DS_Store
*.log

# Editor folders
.vscode/
.idea/

# OS-specific
Thumbs.db
desktop.ini

# Node/Python/Build artifacts (if added later)
node_modules/
__pycache__/
dist/
build/
.env
EOF

# Create README
cat > "$ROOT/README.md" <<EOF
# $REPO

This project demonstrates nested folder creation and GitHub Actions traversal using \`cd\` and \`cat\`. Each folder contains a \`folder.txt\` file with its own name.
EOF

# Initialize Git and prepare for push
cd "$ROOT"
git init
git checkout -b "$BRANCH"
git remote add origin "https://github.com/$OWNER/$REPO.git"
git add .
git commit -m "Initial scaffold with nested folders and GitHub Actions"
# Uncomment when ready to push:
# git push -u origin "$BRANCH"

echo "✅ Project scaffolded in $ROOT and ready to push to GitHub"
