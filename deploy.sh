#!/bin/bash
# See https://medium.com/@nthgergo/publishing-gh-pages-with-travis-ci-53a8270e87db
set -o xtrace
set -o errexit

declare -r SSH_FILE="$(mktemp -u $HOME/.ssh/XXXXX)"
openssl aes-256-cbc \
    -K $encrypted_a2d73c840294_key \
    -iv $encrypted_a2d73c840294_iv \
    -in ".travis/github_deploy_key.enc" \
    -out "$SSH_FILE" -d

chmod 600 "$SSH_FILE" \
    && printf "%s\n" \
    "Host github.com" \
    "  IdentityFile $SSH_FILE" \
    "  LogLevel ERROR" >> ~/.ssh/config

# config
git config --global user.email "hisaharu@gmail.com"
git config --global user.name "Travis CI"

# deploy
mkdir tmp
mv *.html assets images tmp
cd tmp
git init
git add *.html assets images
git commit -m "Automatic build by Travis CI"
git push git@github.com:${GITHUB_REPO}.git master:gh-pages -f
