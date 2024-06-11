# Creating a new repository

> [!TODO]
> re-run all this with no git configuration

First, let's create a sample repository with some files in it. We provide a script for that, but you need to provide it a directory name;
it's typical to name the directory after your repository name. You may choose a name; this tutorial will choose the name `my_project`:
```bash
git clone https://www.github.com/c-dilks/git-tutorial.git
git-tutorial/make_example_project.sh my_project
cd my_project
```
This is just a directory with some text files in it. You can look around, but you won't find anything exciting.

<!--
> [!TIP]
> `git` is not meant to store large files. If you want to store large files, it's better to use another service, _e.g._,
> [GitHub Large File Storage.](https://docs.github.com/en/repositories/working-with-files/managing-large-files/about-git-large-file-storage).
-->

Let's make it a `git` repository. We'll call the "main" branch `main`:
```bash
git init -b main
```
This just creates a subdirectory `.git/`.
This `.git` directory contains all the information about your new `git` repository; you do not need to look at any of its files, or modify them, since you will be using `git` commands instead. The existence of this `.git/` directory makes this current directory a `git` repository.

# Your first commit

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

# Your second commit

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

## Syncing with remotes, e.g., GitHub

`git` becomes much more powerful when you synchronize it with a "remote" repository. Typically you need a _host_ for the
remote repository; some example hosts:

- [GitHub](https://github.com/) - a popular host; most of our [JefferonLab](https://github.com/JeffersonLab) code is hosted here
- [GitLab](https://gitlab.com/) - another popular host; this is the main GitLab host, but it's possible to "self-host" a GitLab instance
- [JLab's GitLab](https://code.jlab.org/) - this is Jefferson Lab's GitLab instance; it is new, and you might not have access to it yet,
  even if you have a JLab account

All of these have similar features, but from the point of view of simply _hosting_ a repository, you will interact with them
in the same way with standard `git` commands. When you start working collaboratively or using Continuous Integration, then you'll
start to see their differences.

Since GitHub is very popular, we'll continue this tutorial assuming you are using GitHub. This assumes that:
- you have a GitHub account
- you have generated an SSH key pair, and uploaded the public key to GitHub

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
