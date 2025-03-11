#!/bin/bash
# @author { @Override } : 14:14 - 20250311
git init
git add .
echo "Enter Commit Message: "
read commit
git commit -m "${commit}"
echo "Please type Branch(https://link): "
read link
git push ${link}

