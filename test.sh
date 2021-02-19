#!/usr/bin/env zsh
set -e
set -x
source ${1-git-quicksave.zsh}

function latest_commit_message() {
  git show --pretty=%s -s
}

function expect_no_diff() {
  DIFF=$(git diff)
  if [ -n "$DIFF" ]; then
    echo Expected no diff, but saw
    echo $DIFF
    exit 1
  fi
}

function expect_n_commits() {
  EXPECTED=$1
  NUM_COMMITS=$(git rev-list HEAD | wc -l)
  if [[ "$NUM_COMMITS" != $1 ]]; then
    echo "Expected $1 commits $2, saw ${NUM_COMMITS}"
    exit 1
  fi
}

export GIT_PAGER=cat

ORIG_DIR=$(realpath $(dirname $0))
TEST_DIR=${ORIG_DIR}/test_repo

rm -rf ${TEST_DIR}
cp -r fixture ${TEST_DIR}
cd ${TEST_DIR}
mv dotgit .git

ORIGINAL_TEXT=$(cat text.txt)

echo 'another line' >> text.txt

git_qs_save


SHOW=$(latest_commit_message)
if [[ "$SHOW" != "Quicksave" ]]; then
  echo "Expected Quicksave, saw"
  echo $SHOW
  exit 1
fi

echo 'third line' >> text.txt
git_qs_save some sort of message
SHOW=$(latest_commit_message)
if [[ "$SHOW" != "Quicksave: some sort of message" ]]; then
  echo "Expected annotated quicksave, saw"
  echo $SHOW
  exit 1
fi

expect_n_commits 4 'after two quicksaves'

git_qs_squash -m 'Got it working!'
expect_n_commits 3 'after squash'

MSG=$(latest_commit_message)
if [[ "$MSG" != "Got it working!" ]]; then
  echo "Unexpected commit message after squash, saw"
  echo $MSG
  exit 1
fi

cd ..
rm -rf ${TEST_DIR}
