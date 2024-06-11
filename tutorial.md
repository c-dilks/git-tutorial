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
commit 9e4d879fab49fcfbabfb4e94f257a7985be6d33c (HEAD -> main)
Author: Christopher Dilks <c-dilks@users.noreply.github.com>
Date:   Mon Jun 10 16:55:18 2024 -0400

    my first git commit
```
- The long hexadecimal number `9e4d879fab49fcfbabfb4e94f257a7985be6d33c` is the "commit hash", a cryptographic hash based on your files, author name,
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
Now you are ready to commit!

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
