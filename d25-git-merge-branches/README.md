# Git Branching and Merging Task Report

## Task Description

The Nautilus application development team requested updates to the Git repository `/opt/cluster.git`. The requirements were:

1. Create a new branch `nautilus` in `/usr/src/kodekloudrepos/cluster` repo from the `master` branch.
2. Copy the `/tmp/index.html` file into the repository.
3. Add and commit this file to the `nautilus` branch.
4. Merge the `nautilus` branch back into the `master` branch.
5. Push the changes to the origin for both branches.

---

## Steps Performed

### 1. SSH into Storage Server

All operations needed to be performed on the storage server:

```bash
ssh natasha@ststor01
```

---

### 2. Navigate to the Cluster Repository

```bash
cd /usr/src/kodekloudrepos/cluster
```

---

### 3. Create and Switch to New Branch

```bash
git checkout -b nautilus
```

---

### 4. Copy `index.html` into the Repository

```bash
cp /tmp/index.html .
```

---

### 5. Stage and Commit the File

```bash
git add index.html
git commit -m "Add index.html to nautilus branch"
```

---

### 6. Merge Branch into Master

Switch to `master` and merge the changes from `nautilus`:

```bash
git checkout master
git merge nautilus
```

---

### 7. Push Both Branches to Origin

```bash
git push origin master
git push origin nautilus
```

---

## Verification

* Verified that both `nautilus` and `master` branches exist locally and on origin:

```bash
git branch -a
git log --oneline
```

* Confirmed that `index.html` is present and tracked in both branches.

---

## Final Status

✅ Task completed successfully.

* `nautilus` branch created.
* `index.html` added and committed.
* Merged into `master`.
* Both branches pushed to origin.

---
