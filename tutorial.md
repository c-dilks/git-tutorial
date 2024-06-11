# Creating a new repository

> [!TODO]
> re-run all this with no git configuration


First, let's create a sample repository. Make a new directory and change to it; you may name the directory whatever you want, but it's good
to name it the same name as the repository. In this example, we'll name the repository `my_project`.
```bash
mkdir my_project
cd my_project
```
Now you may add your files, code, etc.

> [!TIP]
> `git` is not meant to store large files. If you want to store large files, it's better to use another service, _e.g._,
> [GitHub Large File Storage.](https://docs.github.com/en/repositories/working-with-files/managing-large-files/about-git-large-file-storage).

For this tutorial, let's add a couple sample files and a new directory. You may copy and paste each of these command blocks into your shell; note that
there _are_ obvious mistakes in these lists (we will fix them later!):
```bash
cat << EOF > quarks.txt
up
down
strange
weird
charmy
beauty
EOF
```
```bash
mkdir -p data && echo 'a b c d' > data/halls.txt
```
```bash
echo "1 2 3" > one.dat
```
```bash
echo "4 5 6" > two.dat
```

If you run `ls -a`, you'll see the files you created (along with `.` and `..`).
Now let's make this a `git` repository. We'll call the "main" branch `main`:
```bash
git init -b main
```
Re-running `ls -a` will reveal that a directory called `.git/` has been created.
This `.git` directory contains all the information about your new `git` repository; you do not need to look at any of its files, or modify them, since you will be using `git` commands instead. The existence of this `.git/` directory makes this current directory a `git` repository.

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
    one.dat
	quarks.txt
    two.dat

nothing added to commit but untracked files present (use "git add" to track)
```
- "On branch main" means that you are currently on the `main` branch, which you created in the previous step with `-b main`
- "No commits yet" means that you have not added _anything_ to this branch
- "Untracked files" is the list of files that are not being _tracked_ by `git`; they exist in your current directory, but `git` does not care about them.
  - note that only the `data/` directory is shown; if you want to see _all_ the untracked files within, use `git status -u`

To tell `git` to care about certain files, use `git add`. Let's add `quarks.txt` and the full `data/` subdirectory, and assume that we do not want `git` to worry about the `.dat` files:
```bash
git add quarks.txt
```
```bash
git add data
```

Now re-run `git status`. The files under "Changes to be committed" are called "staged files": this means that they are ready to be _committed_ to `git`.

> [!TIP]
> If you want to `git add` _all_ of the untracked files, use the `-A` option:
> ```bash
> git add -A
> ```
<!--`-->

> [!TIP]
> If you staged a file that you did not want to be staged, you may use `git reset` to unstage; let's assume you added `one.dat`:
> ```bash
> git reset one.dat
> ```
> If you want to unstage _all_ the files, just run `git reset` with _no_ arguments:
> ```bash
> git reset
> ```
<!--`-->

Next, let's make a commit, which is basically a "snapshot" of the _staged_ files. You typically will include a _commit message_ which describes the commit, using the `-m` option.
```bash
git commit -m "my first git commit"
```

> [!NOTE]
> If you just run `git commit`, it will open the default text editor, which may
> be `vim`, where you can write your commit message; this is convenient if you
> want to write a longer message. If you're not familiar with `vim`, you may
> use `git config` to change it to another text editor.

If you run `git status`, it will just say that `one.dat` and `two.dat` are untracked (since we haven't added them before). To see your commit, use `git log`:
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

Now, let's work on the files. First, correct the list of quarks. The new version should look something like:
```
up
down
strange
charm
top
bottom
```
Let's also rename one of the files:
```bash
mv data/halls.txt data/jlab_halls.txt
```
Run `git status` and it will say that:
- `quarks.txt` has been modified; this makes sense, we changed it
- `data/halls.txt` has been deleted; this makes sense, since we renamed it, and the new file `data/jlab_halls.txt` is not yet tracked

To see what we have changed, use `git diff`; you'll see something like:
```diff
diff --git a/data/halls.txt b/data/halls.txt
deleted file mode 100644
index 8e13e46..0000000
--- a/data/halls.txt
+++ /dev/null
@@ -1 +0,0 @@
-a b c d
diff --git a/quarks.txt b/quarks.txt
index 140c8be..534f5fa 100644
--- a/quarks.txt
+++ b/quarks.txt
@@ -1,6 +1,6 @@
 up
 down
 strange
-weird
-charmy
-beauty
+charm
+top
+bottom
```
This indicates that all lines have been removed from `data/halls.txt` (since it has been "deleted"), and shows the changes you made to `quarks.txt`

> [!TIP]
> I find this `diff` format a bit hard to read, especially when there are large changes. There are better `diff` tools you can use, for example:
> - [Delta](https://github.com/dandavison/delta)

Let's stage the changes:
```
git add quarks.txt
git add data/halls.txt
git add data/jlab_halls.txt
```

Running `git status` will now show that you _renamed_ `data/halls.txt`.

> [!TIP]
> Notice that you had to add _both_ the original `halls.txt` and `jlab_halls.txt`; you could have alternatively used `git mv` instead of `mv` to rename the file

At this point, you may be annoyed at running all these `git add` commands. You could use `git add -A` to add everything, but that will include the `.dat` files, which we don't want `git` to track. So, let's create a `.gitignore` file. First, let's unstage all our changes to see how this will work:
```bash
git reset
```
We want to ignore all `.dat` files, so add `*.dat` to `.gitignore`; since the `.gitignore` file does not yet exist, run:
```bash
echo '*.dat' > .gitignore
```
Run `git status` and you will notice that `git` now ignores the `.dat` files. Now you may stage _all_ the files `git` cares about:
```bash
git add -A
```
`git status` should say:
```
On branch main
Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
	new file:   .gitignore
	renamed:    data/halls.txt -> data/jlab_halls.txt
	modified:   quarks.txt
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
