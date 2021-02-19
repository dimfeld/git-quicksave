function git_qs_save() {
  MESSAGE="Quicksave"
  if [[ -n "$@" ]]; then
    MESSAGE="Quicksave: $@"
  fi
  git commit -am "$MESSAGE"
}

function git_qs_restore() {
  if [[ $1 != '-f' ]]; then
    read -q 'CONFIRM?Type yes to confirm'
    if [[ $CONFIRM != 'yes' ]]; then
      return
    fi
  fi
  echo 'quick restore'
  git reset --hard HEAD
}

function git_qs_squash() {
  LAST_NON_QUICKSAVE=$(git rev-list -n 1 --grep Quicksave --invert-grep HEAD)
  FILES=$(git diff --name-only ${LAST_NON_QUICKSAVE})
  git reset --soft ${LAST_NON_QUICKSAVE}
  git add ${FILES}
  git commit "$@"
}
