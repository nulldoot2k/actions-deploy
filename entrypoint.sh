#!/bin/bash
# Exit immediately if a pipeline returns a non-zero status.
set -e

echo "🚀 Starting deployment action"

# Here we are using the variables
# - GITHUB_ACTOR: It is already made available for us by Github. It is the username of whom triggered the action
# - GITHUB_TOKEN: That one was intentionally injected by us in our workflow file.

# Creating the repository URL in this way will allow us to `git push` without providing a password
# All thanks to the GITHUB_TOKEN that will grant us access to the repository
REMOTE_REPO="https://nulldoot2k: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@github.com/${GITHUB_REPOSITORY}.git"

# We need to clone the repo here.
# Remember, our Docker container is practically pristine at this point
git clone $REMOTE_REPO repo
cd repo

# Install all of our dependencies inside the container
# based on the git repository Gemfile
echo "⚡️ Installing project dependencies..."
bundle install

# Build the website using Jekyll
echo "🏋️ Building website..."
JEKYLL_ENV=production bundle exec jekyll build
echo "Jekyll build done"

# Now lets go to the generated folder by Jekyll
# and perform everything else from there
cd build

echo "☁️ Publishing website"

# We don't need the README.md file on this branch
sudo rm -f README.md

# Now we init a new git repository inside _site
# So we can perform a commit
sudo git init
echo "khoi tao"
sudo git config --global user.name "nulldoot2k"
echo "Add 1"
sudo git config --global user.email "companydatv412@gmail.com"
echo "Add 2"
sudo git add .
# That will create a nice commit message with something like:
# timedatectl set-timezone Asia/Ho_Chi_Minh
# Github Actions - Fri Sep 6 12:32:22 UTC 2019
sudo git commit -m "Github Actions - $(date)"
# GIT_COMMITTER_DATE="$(date)" git commit --amend --no-edit --date "$(date)"
# git commit -m "Github Actions update latest"
echo "Build branch ready to go. Pushing to Github..."
# Force push this update to our gh-pages
sudo git push --force $REMOTE_REPO master:gh-pages
# Now everything is ready.
# Lets just be a good citizen and clean-up after ourselves
sudo rm -fr .git
cd ..
sudo rm -rf repo
echo "🎉 New version deployed 🎊"
