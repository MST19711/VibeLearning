#!/bin/bash

# GitHub Repository Setup Script for Photo Watermark
# This script helps you set up the GitHub repository and push your code

echo "🚀 Photo Watermark - GitHub Setup Script"
echo "========================================"
echo ""

# Check if GitHub CLI is installed
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI (gh) is not installed."
    echo "Please install it first: https://cli.github.com/"
    echo ""
    echo "Alternatively, you can manually create a repository on GitHub.com"
    echo "and then run: git remote add origin <your-repo-url>"
    exit 1
fi

# Check if user is logged in to GitHub CLI
if ! gh auth status &> /dev/null; then
    echo "❌ You are not logged in to GitHub CLI."
    echo "Please run: gh auth login"
    exit 1
fi

echo "✅ GitHub CLI is ready!"
echo ""

# Repository details
REPO_NAME="photo-watermark-macos"
REPO_DESCRIPTION="A macOS application for adding watermarks to photos, built with Flutter"

# Create the repository
echo "📦 Creating GitHub repository..."
gh repo create "$REPO_NAME" \
    --description "$REPO_DESCRIPTION" \
    --public \
    --confirm

if [ $? -eq 0 ]; then
    echo "✅ Repository created successfully!"
    
    # Add remote and push
    echo "📤 Pushing code to GitHub..."
    git remote add origin "https://github.com/$(gh api user --jq .login)/$REPO_NAME.git"
    git branch -M main
    git push -u origin main
    
    echo "✅ Code pushed successfully!"
    echo ""
    echo "🎉 Setup complete!"
    echo "Repository URL: https://github.com/$(gh api user --jq .login)/$REPO_NAME"
else
    echo "❌ Failed to create repository. It might already exist."
    echo "Please manually create the repository and add the remote."
fi