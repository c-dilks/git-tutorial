# Git Basics: a local repository
## Creating a new repository

First, let's create a sample repository with some files in it. We provide a script for that, but you need to provide it a directory name;
it's typical to name the directory after your repository name. You may choose a name; this tutorial will choose the name `my_project`:
```bash
git clone https://www.github.com/c-dilks/git-tutorial.git
git-tutorial/make_example_project.sh my_project
cd my_project
```
This is just a directory with some text files in it. You can look around, but you won't find anything exciting.

Let's make it a `git` repository. We'll call the "main" branch `main`:
```bash
git init -b main
```
This just creates a subdirectory `.git/`.
This `.git` directory contains all the information about your new `git` repository; you do not need to look at any of its files, or modify them, since you will be using `git` commands instead. The existence of this `.git/` directory makes this current directory a `git` repository.

> [!IMPORTANT]
> `git` is not meant to store large files. If you want to store large files, it's better to use another service, _e.g._,
> [GitHub Large File Storage.](https://docs.github.com/en/repositories/working-with-files/managing-large-files/about-git-large-file-storage).

## Your first commit

At any time, you may run `git status` to check the current state of your repository. Let's do it now:
```bash
git status
```
```
On branch main

No commits yet

Untracked files:
  (use "git add <file>..." to include in what will be committed)
	data/
	info/
	lists.txt
	sample_data.dat

nothing added to commit but untracked files present (use "git add" to track)
```
- "On branch main" means that you are currently on the `main` branch, which you created in the previous step with `-b main`
- "No commits yet" means that you have not added _anything_ to this branch
- "Untracked files" is the list of files that are not being _tracked_ by `git`; they exist in your current directory, but `git` does not care about them.

> [!TIP]
> For directories, only the directory name is shown. Use `git status -u` to see within.

To tell `git` to care about certain files, use `git add`. Let's add `lists.txt` and the full `info/` subdirectory, and assume that we do not want `git` to worry about the `.dat` files:
```bash
git add lists.txt
git add info
```

Now re-run `git status`. The files under "Changes to be committed" are called "staged files", which means that they are ready to be _committed_ to `git`.

> [!TIP]
> If you want to `git add` _all_ of the untracked files, use the `-A` option:
> ```bash
> git add -A
> ```
<!--`-->

> [!TIP]
> If you staged a file that you did not want to be staged, use `git reset` to unstage; let's assume you added `sample_data.dat`:
> ```bash
> git reset sample_data.dat
> ```
> If you want to unstage _all_ the files, just run `git reset` with _no_ arguments:
> ```bash
> git reset
> ```
<!--`-->

Next, let's make a commit, which is basically a "snapshot" of the _staged_ files. You should include a _commit message_ which describes the commit, using the `-m` option.
```bash
git commit -m "my first git commit"
```

> [!IMPORTANT]
> If you just run `git commit`, it will open the default text editor, which may
> be `vim`, where you can write your commit message; this is convenient if you
> want to write a longer message, but if you're not familiar with `vim`, you may
> use `git config` to change it to another text editor.

Now if you run `git status`, it will just say that `data/` and `sample_data.dat` are untracked (since we haven't added them before). To see your commit, use `git log`:
```bash
git log
```
```
commit 8d2de90d0635e3e02160a62fd9920c1c29b1ae2f
Author: Christopher Dilks <c-dilks@users.noreply.github.com>
Date:   Tue Jun 11 09:43:18 2024 -0400

    my first git commit
```
- The long hexadecimal number `8d2de90d0635e3e02160a62fd9920c1c29b1ae2f` is the "commit hash", a cryptographic hash based on your files, author name,
commit message, and more; it is a _unique_ identifier for this commit.
- `HEAD -> main` means that your current state, called `HEAD`, is at the same point as the current `main` branch
- The author name, date, and commit message are also shown

You have now committed to `git`!

> [!TIP]
> It's good practice to commit often, and to make each commit
> a focused change of your code. To help keep your commits
> focused, consider using
> [conventional commits](https://www.conventionalcommits.org/)
>
> If your commits are small, it's easier for your future self
> and others to follow what you did, and it makes it easier
> to do `git` operations such as
> - `git revert`: undo a commit with a new commit
> - `git cherry-pick`: replay a commit elsewhere
> - `git rebase`: move a set of consecutive commits elsewhere

## Your second commit

Let's get some work done:

1. Open `lists.txt` and fix its obvious problems.
2. Rename `info/halls.txt` to `info/jlab_halls.txt`.

Run `git status` and it will say that:
- `lists.txt` has been modified; this makes sense, we changed it
- `info/halls.txt` has been deleted; this makes sense, since we renamed it, but the new file `info/jlab_halls.txt` is not yet tracked

To see what we have changed, use `git diff`; you'll see something like:
```diff
diff --git a/info/halls.txt b/info/halls.txt
deleted file mode 100644
index 8e13e46..0000000
--- a/info/halls.txt
+++ /dev/null
@@ -1 +0,0 @@
-a b c d
diff --git a/lists.txt b/lists.txt
index b0ae735..c55cbff 100644
--- a/lists.txt
+++ b/lists.txt
@@ -2,7 +2,7 @@ LIST OF QUARKS
 ==============
 up
 down
-weird
+strange
 charm
 top
 bottom
@@ -10,11 +10,11 @@ bottom
 LIST OF JEFFERSON LAB HALLS
 ===========================
 A
+B
 C
 D
 
 LIST OF NUCLEONS
 ================
-electron
 proton
 neutron
```
This indicates that all lines have been removed from `info/halls.txt` (since it has been "deleted"), and shows the changes you made to `lists.txt`.

> [!TIP]
> I find this `diff` format a bit hard to read, especially when there are large changes. There are better `diff` tools you can use, for example:
> - [Delta](https://github.com/dandavison/delta)

Let's stage the changes:
```
git add lists.txt
git add info/halls.txt
git add info/jlab_halls.txt
```

Now running `git status` will now show that you _renamed_ `data/halls.txt`.

> [!TIP]
> Notice that you had to add _both_ the original `halls.txt` and
> `jlab_halls.txt`; you could have alternatively used `git mv` instead of `mv`
> to rename the file

At this point, you may be annoyed at running all these `git add` commands. You
could use `git add -A` to add everything, but that will include the untracked
`.dat` files, which we don't want `git` to track. So, let's create a
`.gitignore` file.

We want to ignore all `.dat` files, so add `*.dat` to `.gitignore`; since the `.gitignore` file does not yet exist, run:
```bash
echo '*.dat' > .gitignore
```
Run `git status` and you will notice that `git` now ignores the `.dat` files, and says `.gitignore` is untracked. Let's just
use `-A` to add it:
```bash
git add -A
```
`git status` should say:
```
On branch main
Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
	new file:   .gitignore
	renamed:    info/halls.txt -> info/jlab_halls.txt
	modified:   lists.txt
```

> [!TIP]
> What if you forgot to run `git diff`, and you want to see the changes? Try running `git diff` and you'll see _no_ changes! To see
> the _staged_ changes, you need to run
> ```bash
> git diff --staged
> ```
<!--`-->

> [!TIP]
> All of these `git` commands have multiple options; use the `--help` option for further guidance, for example,
> ```bash
> git diff --help
> ```
<!--`-->

Now you are ready to commit:
```bash
git commit -m "my second git commit"
```
Run `git log` to see all your commits:
```bash
git log
```
```
commit 9257afc0fd842b12a3ebb844f5b95cf849c2acb7 (HEAD -> main)
Author: Christopher Dilks <c-dilks@users.noreply.github.com>
Date:   Tue Jun 11 09:44:16 2024 -0400

    my second git commit

commit 8d2de90d0635e3e02160a62fd9920c1c29b1ae2f
Author: Christopher Dilks <c-dilks@users.noreply.github.com>
Date:   Tue Jun 11 09:43:18 2024 -0400

    my first git commit
```

## Checking out other commits

Up until now, it seems that `git commit` is just like pressing the "save
button", but `git` offers so much more. For example, you can revert your
repository to any previous commit. Since there are only 2 commits, and you are
on the later one, let's roll back to the previous commit; note that your _commit hash_
will certainly be different from this example (so don't just copy paste this command):
```
git checkout 8d2de90d0635e3e02160a62fd9920c1c29b1ae2f
```
It will complain that you are in a 'detached HEAD state'. Don't worry, `git` is not talking about
your actual head on top of your shoulders, rather it's talking about the current state of your repository,
which is called `HEAD`. It is "detached" since it is not pointing to any branch, and your only branch is
`main`, which is currently at the later commit.

Take a look at your code, and notice that things are reverted; don't make any changes, otherwise you'll
need to figure out how to make a branch (later in the tutorial).

> [!TIP]
> Usually the first 7 characters of a commit hash are unique enough, so we could have gotten the same
> result with
> ```bash
> git checkout 8d2de90
> ```
> You may often see this representation on places like GitHub. When in doubt, just use the full commit hash;
> some commands don't work correctly if you use the short hash.
<!--`-->

Let's go back to the `main` branch. In `git log`, you'll notice the `main` branch is at the later commit, so
you can just checkout `main` rather than copy-pasting the commit hash:
```bash
git checkout main
```
Now your `HEAD` is attached, since it's pointing at your `main` branch.

> [!TIP]
> Someday you may want to `checkout` what you checked out previously. Just like the `cd -` command, you can use a
> hyphen to mean "checkout the last place `HEAD` was":
> ```bash
> git checkout -
> ```
> If you do this multiple times, you'll oscillate between the two commits.
<!--`-->

# Remote git repositories (e.g., GitHub)

`git` becomes much more powerful when you synchronize it with a "remote" repository. Typically you need a _host_ for the
remote repository; some example hosts:

- [GitHub](https://github.com/) - a popular host; most of our [JefferonLab](https://github.com/JeffersonLab) code is hosted here
- [GitLab](https://gitlab.com/) - another popular host; this is the main GitLab host, but it's possible to "self-host" a GitLab instance
- [JLab's GitLab](https://code.jlab.org/) - this is Jefferson Lab's new GitLab instance

All of these have similar features, but from the point of view of simply
_hosting_ a `git` repository, you will interact with them in the same way with
standard `git` commands. When you start working collaboratively or using
Continuous Integration, then you'll start to see their differences.

> [!NOTE]
> To fully benefit from this tutorial, you'll need an account on one of these; example commands
> will assume GitHub. If you do not want to create an account, you may still keep following
> the tutorial, keeping in mind that:
> - you must use HTTPS addresses when running `git clone`, replacing
>   ```
>   git@github.com:
>   ```
>   with
>   ```
>   https://github.com/
>   ```
> - you will not be able to run `git push`

## Getting Access to GitHub/GitLab/`code.jlab.org`

To use any of the above, you need an account on the website, and an SSH key pair: a public
key, to be uploaded to the website, and a private key, which you must not share. Think of
your public key as a padlock and your private key as the key to that padlock. To generate a new
key pair, you may use `ssh-keygen`. First, navigate to your home directory, then run it:
```bash
ssh-keygen -t ed25519
```
The `-t` option is the key type; both GitHub and GitLab accept `ed25519` keys, and possibly
others. Next:
- It asks you to "Enter a file in which to save the key"
  - the default is only okay if that's your only key (unlikely), so choose
    another name; be sure to use the same suggested location, however (`.ssh` within
    your home directory)
  - I typically use a file name that includes the server name "GitHubAuthentication"
- Enter a passphrase; you should probably do this (blank means no passphrase, which means
  your private key is unencrypted, which means if someone steals it, they can just use it)

Your key pair is now available (should be in `~/.ssh/`). The version that ends in `.pub` is
public key, and the version that has no file extension is the private key.

Next, upload your **public** key (the one with `.pub`) to your account.

Since GitHub is very popular, we'll continue this tutorial focused on GitHub:
1. in the upper right corner, click your avatar
1. click "Settings"
1. click "SSH and GPG keys"
1. click "New SSH key
1. give it a title; "main authentication key" is good enough
1. the type should be "Authentication key"
1. copy and paste your **PUBLIC** key to the large box
1. click "Add SSH key"

Finally, configure your SSH client to use this key for GitHub. Add the following lines
to your `~/.ssh/config` file (change the key name to yours):
```
# GitHub
Host github.com
  PreferredAuthentications publickey
  IdentityFile ~/.ssh/GitHubAuthentication
```

Now you are good to go!

> [!TIP]
> You will probably get annoyed at having to enter yet another password each time you
> use certain `git` commands. There are ways to "manage" your keys such that, for example,
> you only need to enter your password once every 8 hours. The `ssh-agent` program is
> one way to do something like this; this is outside the scope of this tutorial.

## Creating a repository on GitHub

First, we need to create a GitHub repository. In the upper right corner, click the plus sign, then "New repository". Then,
1. give it a name; our name was `my_project` (note it doesn't have to match the directory name, but that's conventional)
1. decide if you want it public or private; private means no one but you can see it, but certain GitHub features may be disabled
  (depending on your GitHub account type)
1. you are welcome to set the other settings, but the defaults are good enough for this tutorial
1. click "Create repository" at the bottom

Now you will see a bunch of text telling you what to do. Some of these commands will look familiar, because you already did most of this!
Go back to your shell, in your _local_ `git` repository, so that we can link it to your new _remote_ GitHub repository.

List the remote repositories that your local repository knows about:
```bash
git remote -v
```
There are none, since we haven't added any. Also, `-v` is for verbose, which is useful. Let's add your remote GitHub repository.

On your GitHub repositories front page, you'll see an example `git remote add...` command; you can run that one. My user name is `c-dilks`
and my repository name is `my_project`, so my command is:
```bash
git remote add origin git@github.com:c-dilks/my_project.git
```
- `add` means we are adding a new remote
- `origin` is the _name_ of this remote; `origin` is the standard default name for the _primary_ remote repository to which you will sync
- `git@github.com:[USER_NAME]/[REPOSITORY_NAME].git` is the SSH address of your repository (HTTPS addresses are discouraged nowadays)

Now run `git remote -v` again, and you'll see your remote:
```bash
git remote -v
```
```
origin	git@github.com:c-dilks/my_project.git (fetch)
origin	git@github.com:c-dilks/my_project.git (push)
```
- the name and SSH address are shown
- `fetch` means "for downloading" and `push` means "for uploading"; they are usually the same address

Next, synchronize your local repository with the remote by
_pushing_ your local `main` branch (assumes your `HEAD`
points to `main`):
```bash
git push
```
```
fatal: The current branch main has no upstream branch.
To push the current branch and set the remote as upstream, use

    git push --set-upstream origin main
```
This failed because the `main` branch does not yet
exist on the `origin` remote.

> [!NOTE]
> If you got a different failure, probably "Permission denied",
> then your SSH client is not correctly configured.

Do what it says, which will
_create_ the `main` branch on the `origin` remote:
```bash
git push --set-upstream origin main
```

Now refresh your web browser's view of your repository, and
now you'll see your files!

**Exercise**: make more changes, commit, and push. The sequence after making your change should be something like:
```bash
git status
git diff
git add -A
git commit -m "my third git commit"
git push
```
Notice you didn't need `--set-upstream origin main` in your
`git push` command. This is because:
- your remote `main` branch exists
- your local `main` branch is _tracking_ your remote `main`
  branch; since your remote is named `origin`, your remote
  `main` branch is named `origin/main` (you'll see that
  in commands such as `git status`)

## Working on multiple computers

It's 2024 and many of us work on more than one computer. Thus
we will eventually have more than one copy of a `git`
repository. There are two commands that are used to get
updates from the common remote repository: `fetch` and `pull`.

`git fetch` is used to just get the information from the
remote repository; it will not alter your local files. It
needs the remote name (`origin`, here):
```bash
git fetch origin
```

On the other hand, `git pull` will not only `fetch`, but also
will _synchronize_ your local repository with the remote,
altering your local files to match the remote files:
```bash
git pull
```
So, if you are working on your office computer and want to
go work from home, first commit to `git` and `push` to remote.
Then when you are on your home computer, run `git pull` and
get back to work!

> [!NOTE]
> What if you forget to `pull` and push commits? `git` may
> complain about conflicts. Follow the directions, and
> [see here for more guidance](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/addressing-merge-conflicts/resolving-a-merge-conflict-using-the-command-line)

# Working with Others
## Forks and Branches

In the interest of time, we'll attempt to cover _both_ forks
and branches. Everything we'll cover here about _branches_
applies also when you do _not_ create a fork; we want to
cover forking, however, since that will allow to make
contributions to _any_ GitHub repository.

> [!NOTE]
> Forking is a concept specific to GitHub, whereas branching
> is a `git` concept and applies to any remote host.
> - A fork is basically a _copy_ of the _full_ repository, a
>   copy that _you_ may do whatever _you_ want with
> - A branch is a pointer to a certain commit; this will
>   be clearer after we create a branch

Let's say you want to make a contribution to
[Iguana](https://github.com/JeffersonLab/iguana).
Fork it:
- upper right corner, click "Fork", then "Create Fork"

Next, _clone_ your fork, which will download the repository to
your current working directory into a folder named `iguana`.
- In the upper right corner, click the green "Code" button
- Choose the SSH tab (if you're not logged in, use HTTPS, but
  you won't be able to `git push`)
- Copy the `git@github.com` URL, and use it in the following
  command (replace `SSH_URL`):
```bash
git clone SSH_URL
cd iguana
```

> [!NOTE]
> You can clone any GitHub (or GitLab) repository.

If you run `git remote -v`, you'll see the `origin` remote
is already set to that clone URL. Since we want to also
synchronize to the [_primary_ `iguana` fork](https://github.com/JeffersonLab/iguana), let's also add that remote; it
is conventional to name the _primary_ fork remote `upstream`.
```bash
git remote add upstream git@github.com:JeffersonLab/iguana.git
```
My result of `git remote -v` looks like:
```
origin	git@github.com:c-dilks/iguana.git (fetch)
origin	git@github.com:c-dilks/iguana.git (push)
upstream	git@github.com:JeffersonLab/iguana.git (fetch)
upstream	git@github.com:JeffersonLab/iguana.git (push)
```

> [!NOTE]
> Your local `main` branch tracks your fork's `main` branch,
> `origin/main` (run `git status` to see), but _not_ the
> primary fork's `main` branch, `upstream/main`

Update your local repository's _knowledge_ about the
`upstream` remote; this does _not_ change any files
within your repository (i.e., your `HEAD`), except for stuff
in your `.git/` subdirectory. This is called _fetching_:
```bash
git fetch upstream
```
You'll see all the branches and tags that are on `upstream`.

> [!NOTE]
> Running `git fetch origin` will fetch from your fork, but
> that won't do anything at this time since you _just_ created
> your fork, and there is nothing new to fetch

Now you are ready to contribute to `iguana`!

You can get started working, but you are currently on the
`main` branch. It is wise to create a new branch first.
Choose a name that you can remember, something that is
related to the work you will do. In this to tutorial, we'll
name it `tutorial-branch`. To create the branch and check
it out, run:
```bash
git checkout -b tutorial-branch
```
Running `git status` will show that you're on your
new branch.

Now you are _actually_ ready to contribute to `iguana`!

Go ahead and edit some files, then make a `git commit`. When
you `git push`, you will be pushing to _your_ branch
(`tutorial-branch`) on _your_ fork; the first time you run
`git push`, you'll need
`--set-upstream origin tutorial-branch`, but every time after
you can just run `git push`.

> [!TIP]
> Some more helpful commands for working with branches:
> - get the current branch name:
> ```bash
> git rev-parse --abbrev-ref HEAD
> ```
> - list all the local branches, sorted:
> ```bash
> git branch --sort=-committerdate --column dense
> ```
> - list all the remote branches:
> ```bash
> git branch --sort=-committerdate --column dense --remote
> ```
> - be verbose:
> ```bash
> git branch -vv
> git branch -vv --remote
> ```
<!--`-->

> [!TIP]
> Git commits form a Directed Acyclic Graph (DAG). Each commit
> may have one or more _parent_ commits, and a commit can
> have one or more subsequent _child_ commits. To see the
> `iguana` commit DAG:
> - click the "Insights" tab on the repository webpage
> - click "Network Graph" on the left
> To see the DAG locally:
> ```bash
> git log --decorate --oneline --graph
> ```
> This just shows `HEAD` and the commits that lead to it; to
> see _everything_, add the `--all` option.
<!--`-->

> [!TIP]
> Iguana's commit DAG is _linear_, since Iguana merges pull
> requests with the _squash_ method. Other repositories use
> different methods, _e.g._, `coatjava`. Clone it and take
> a look!

> [!TIP]
> Some of these `git` commands are long and hard to remember.
> It's useful to make _aliases_, which you can add to your
> `~/.gitconfig`. Here are my aliases (use the `git`
> documentation if you want to know what they do):
> ```ini
> [alias]
>   g="log --decorate --oneline --graph"
>   ga="log --decorate --oneline --graph --all"
>   s="status"
>   d="diff"
>   ds="diff --staged"
>   dn="diff --name-only"
>   a="add"
>   c="commit"
>   ca="commit -a"
>   p="push"
>   pf="push --force-with-lease"
>   b="branch --sort=-committerdate --column=dense"
>   bc="rev-parse --abbrev-ref HEAD"
>   br="branch --sort=-committerdate --column=dense --remote"
>   bv="branch -vv"
>   co="checkout"
>   cob="checkout -b"
>   m="merge"
>   r="rebase"
>   rc="rebase --continue"
>   rrhh="reset --hard"
>   rv="remote -v"
>   u="pull"
>   f="fetch"
>   fo="fetch origin"
>   fu="fetch upstream"
> ```
> For example, `git s` will run `git status`
<!--`-->

## Keeping up-to-date with Upstream

While you are working on your branch, work may be ongoing
on other branches, including `upstream/main`. It's a good
idea to keep your branch up-to-date with respect to upstream
changes. You can do this a few different ways:

1. Backmerging

Merge the upstream's `main` branch into yours; this is
sometimes called "backmerging". In summary, run:
```bash
git fetch upstream
git merge upstream/main
git push
```

2. Rebasing

Alternatively, _rebase_ your branch onto `upstream/main`;
in summary, run:
```bash
git fetch upstream
git rebase upstream/main
git push --force-with-lease
```

The choice between (1) and (2) depends on your preference, and
the preference of the `upstream` maintainers; (1) is easier
whereas (2) creates a cleaner DAG at the cost of rewriting
`git` history (which is why `--force-with-lease` is needed).

- More details: [Merging vs. Rebasing](https://www.atlassian.com/git/tutorials/merging-vs-rebasing)

In either (1) or (2), you may experience CONFLICTs. This can
happen when `git` cannot decide which changes to keep/delete
between your branch and `upstream/main`. Conflict resolution
is beyond the scope of this tutorial; for guidance, see:

- [Merge conflict resolution](https://www.atlassian.com/git/tutorials/using-branches/merge-conflicts)
- [Rebase conflict resolution](https://www.atlassian.com/git/tutorials/rewriting-history/git-rebase)

Furthermore, your fork's `main` branch may fall behind
`upstream/main`. The easiest way to update it is to:
```bash
git checkout main   # switch to your 'main'
git fetch origin
git merge origin/main
git push
```
If you don't commit to `main`, you won't have to worry
about conflicts on `main`.

## Pull Requests

A pull request (PR) is a proposal to merge one branch into
another, typically your development branch into the
upstream's `main` branch. If you want your code to be
included in `main`, make a PR.

> [!NOTE]
> GitLab calls these "Merge Requests"

You can start a Pull Request by going to the `upstream`
repository's webpage on GitHub. You might already see
a notification about your branch and a button to create
a PR; if so, just click that. If not:
- go to the pull requests tab
- click new pull request
- since your branch is on a fork, click "compare
  across forks"
- set the head repository to your fork
- set the head branch to your branch

Then fill out the form. Before clicking the final "create
pull request":
- if you are _ready_ to be reviewed, just click it
- if your branch is still a work in progress, click the
  drop down arrow, and choose "draft pull request"

> [!TIP]
> It's perfectly fine (and _preferred_) to create a **draft**
> PR, even as early as your first commit; this
> will inform maintainers of your _intent_, and will trigger
> Continuous Integration (automated tests, etc.)

In your PR, there are 4 tabs:
- Conversation: this is the history, things that happened,
  and review comments and conversations
- Commits: the list of commits starting from the first commit
  that comes after the first commit that is common between
  your branch and the target branch, and ending with the
  last commit, the one your branch points to
- Checks: the Continuous Integration (CI) tests, which run
  automatically, typically triggered by each commit; common
  tests include
  - build tests
  - runtime tests
  - validation
- Files changed: perhaps the most important tab, this shows
  the `git diff` between your branch and the target branch

When you are ready for your PR to be _reviewed_,
click the "mark as ready" button, which will change your
PR state from "draft" to "open". If you want to
abandon your PR, _close_ it (you can always
re-open it, if needed).

Once your PR is open, others may review it; you can also
request reviews from specific people. They may:
- approve it, and not request any changes
- request changes, giving feedback as comments; in this case
  respond to all of their "conversations", and mark them
  as resolved when you have "resolved" them
- reject it, by closing it; this is rare, but it's always good
  to create draft PRs, in case a maintainer steps in and says
  "hey, this is a bad idea" sooner rather than later

If your PR is approved, either you or the maintainer may
_merge_ it into the `main` branch. At this point, you may
delete your branch (click the delete branch button), or
it may be automatically be deleted. Since your branch has
been merged, there is no need to keep it around (and you can
always restore it anyway).
