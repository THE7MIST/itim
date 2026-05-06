#!/bin/bash

# Create repository folder
mkdir git_merge_demo
cd git_merge_demo

# Initialize git repository
git init

# Create initial file in main branch
echo "This line is from main branch" > data.txt

git add data.txt
git commit -m "Initial commit on main"

# Take branch names from user
echo "Enter first branch name:"
read branch1

echo "Enter second branch name:"
read branch2

# ----------------------------
# Create first branch
# ----------------------------
git checkout -b $branch1

echo "Change added from $branch1 branch" > data.txt

git add data.txt
git commit -m "Changes from $branch1"

# ----------------------------
# Go back to main
# ----------------------------
git checkout master

# ----------------------------
# Create second branch
# ----------------------------
git checkout -b $branch2

echo "Different change added from $branch2 branch" > data.txt

git add data.txt
git commit -m "Changes from $branch2"

# ----------------------------
# Return to main
# ----------------------------
git checkout master

echo ""
echo "========================================="
echo "Repository and branches created."
echo "Both branches modified same file differently."
echo "Now perform merge manually to create conflict."
echo "========================================="

echo ""
echo "Run these commands manually:"
echo ""

echo "git merge $branch1"
echo "git merge $branch2"

echo ""
echo "Second merge should create merge conflict."
echo "Resolve conflict manually inside data.txt"
echo ""

echo "After resolving:"
echo "git add data.txt"
echo 'git commit -m "Resolved merge conflict"'

echo ""
echo "To verify final history:"
echo "git log --oneline --graph --all"

echo ""
echo "To verify final file content:"
echo "cat data.txt"
