#!/bin/bash

# Create new Git repository
mkdir git_sce1
cd git_sce1

# Initialize git
git init

# ----- 1st Commit -----
echo "This is first file" > first.txt

git add first.txt
git commit -m "1st commit"

# ----- 2nd Commit -----
echo "This is second file" > second.txt

git add second.txt
git commit -m "2nd commit"

# ----- 3rd Commit -----
echo "This is third file" > third.txt

git add third.txt
git commit -m "3rd commit"

# ----- Show Logs -----
echo ""
echo "===== GIT LOG ====="

git log --oneline
