#!/bin/bash

REPO_OWNER="bensocho"
REPO_NAME="little-apples"

COMMIT_SHA=$(curl -s "https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/commits/master" | grep sha | head -n 1 | cut -d'"' -f4)
echo $COMMIT_SHA

