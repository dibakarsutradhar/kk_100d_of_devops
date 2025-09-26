# Task Report: Git Repository Clone on Storage Server

## Objective

The Nautilus DevOps team required cloning of an existing Git repository into a specified directory on the Storage Server in Stratos DC.

### Requirements:

1. Clone the repository `/opt/cluster.git`.
2. Target directory: `/usr/src/kodekloudrepos`.
3. Perform the task using the `natasha` user.
4. Ensure no changes to repository content, permissions, or existing directories.

---

## Steps Performed

### 1. Verified Git installation

```bash
[natasha@ststor01 ~]$ git --version
git version 2.47.3
```

✅ Git is installed.

---

### 2. Verified source repository and target directory

```bash
[natasha@ststor01 ~]$ ls -ld /opt/cluster.git
drwxr-xr-x 7 natasha natasha 4096 Sep 26 16:58 /opt/cluster.git

[natasha@ststor01 ~]$ ls -ld /usr/src/kodekloudrepos
drwxr-xr-x 2 natasha natasha 4096 Sep 26 16:58 /usr/src/kodekloudrepos
```

✅ Both the repository and target directory exist.

---

### 3. Cloned repository into `/usr/src/kodekloudrepos`

```bash
[natasha@ststor01 ~]$ cd /usr/src/kodekloudrepos/
[natasha@ststor01 kodekloudrepos]$ git clone /opt/cluster.git
Cloning into 'cluster'...
warning: You appear to have cloned an empty repository.
done.
```

✅ Repository successfully cloned as `cluster`.
ℹ️ Warning indicates the repository is empty (no commits/files yet).

---

### 4. Checked repository status

Initially attempted from `/usr/src/kodekloudrepos`:

```bash
[natasha@ststor01 kodekloudrepos]$ git status
fatal: not a git repository (or any of the parent directories): .git
```

This failed because `kodekloudrepos` itself is not a repo — the actual repo is inside `cluster`.

Corrected by checking inside the `cluster` directory:

```bash
[natasha@ststor01 kodekloudrepos]$ cd cluster
[natasha@ststor01 cluster]$ git status
On branch master

No commits yet
nothing to commit (create/copy files and use "git add" to track)
```

✅ Repository is valid but empty, as expected.

---

## Final State

* Git repository `/opt/cluster.git` was successfully cloned into `/usr/src/kodekloudrepos/cluster`.
* Repository is empty (no commits yet), which is consistent with the source.
* No permissions or directories were altered.
