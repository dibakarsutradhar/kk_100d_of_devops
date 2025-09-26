# Git Repository Setup Report

**Prepared by:** DevOps Team
**Date:** 26th September 2025
**Server:** Storage Server – Stratos Datacenter

---

## Objective

The Nautilus development team requested the creation of a new Git repository for their application development project.
The requirements were:

1. Install Git on the Storage Server using `yum`.
2. Create a **bare Git repository** named `/opt/blog.git`.

---

## Implementation Steps

### 1. Install Git

Executed the following command to install Git and its dependencies:

```bash
sudo yum install -y git
```

Verified installation with:

```bash
git --version
```

---

### 2. Create Bare Repository

A bare repository was created in `/opt` as requested:

```bash
sudo git init --bare /opt/blog.git
```

Checked the repository structure:

```bash
ls -la /opt/blog.git
```

Expected files and directories confirmed:

```
branches  config  description  HEAD  hooks  info  objects  refs
```

---

## Verification

To confirm that the repository is bare, ran:

```bash
git --git-dir=/opt/blog.git status
```

Output:

```
fatal: This operation must be run in a work tree
```

This message verifies that `/opt/blog.git` is indeed a **bare repository** (since bare repos do not contain a working tree).

---

## Conclusion

* Git was successfully installed on the Storage Server.
* A bare repository `/opt/blog.git` was created and verified.
* The repository is now ready for the Nautilus development team to clone and use for their project.
