
When experimenting or refactoring code, it's common to go down a path that
doesn't work out and want to back out your recent changes. This is, of course,
much easier to do if you have a recent checkpoint or two of changes.

With that in mind, this is a set of functions to make a videogame-style quicksave feature for git
that should assist in that workflow.

This is definitely a work-in-progress and if you have any ideas for
ways to enhance it, please let me know!

Also, right now these are only tested with zsh. I plan to support bash and vim
as well in the future.

# Installation

Just clone the repository and you should be good to go.

```
git clone git@github.com:dimfeld/git-quicksave.git

# In .zshrc
source git-quicksave/git-quicksave.zsh

alias gqs=git_qs_save
alias gqr=git_qs_restore
alias gqc=git_qs_squash
```

# Usage

Right now there are three functions in this package. This is a new project and hasn't been widely tested yet, so
I recommend using them with care, but none of the functions are particularly complicated.

`git_qs_save` commits all changed files (tracked and untracked) with a commit message of "Quicksave". Any arguments
will be appended to the commit message so you can label your quicksaves.

`git_qs_restore` runs `git reset --hard HEAD` to reset to the latest quicksave.
It does ask for confirmation unless you pass the `-f` flag.

`git_qs_squash` can save your work more permanently. It finds the latest string of contiguous commits
with the word "Quicksave" and squashes them together into a single commit. Any arguments will be passed
to the `git commit` command for the new commit.



