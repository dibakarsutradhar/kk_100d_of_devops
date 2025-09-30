# Git Remote Update and Commit Report

## Task Description

The xFusionCorp development team requested updates to the Git repository workflow for the `media` project. The repository is maintained under `/opt/media.git` and cloned under `/usr/src/kodekloudrepos/media` on the Storage server in Stratos DC.

The following requirements were completed:

1. Add a new remote named **`dev_media`** pointing to `/opt/xfusioncorp_media.git`.
2. Copy the file `/tmp/index.html` into the repository.
3. Add and commit the file to the `master` branch.
4. Push the updated `master` branch to the newly added remote.

---

## Steps Performed

### 1. SSH into Storage Server

```bash
ssh natasha@ststor01
```

---

### 2. Navigate to Media Repository Clone

```bash
cd /usr/src/kodekloudrepos/media
```

---

### 3. Add New Remote

```bash
git remote add dev_media /opt/xfusioncorp_media.git
```

Verification:

```bash
git remote -v
```

Output:

```
origin    /opt/media.git (fetch)
origin    /opt/media.git (push)
dev_media /opt/xfusioncorp_media.git (fetch)
dev_media /opt/xfusioncorp_media.git (push)
```

---

### 4. Copy File into Repo

```bash
cp /tmp/index.html .
```

---

### 5. Stage and Commit the File

```bash
git add index.html
git commit -m "Add index.html to master branch"
```

---

### 6. Push Master Branch to New Remote

```bash
git push dev_media master
```

---

## Verification

* **File presence:**

```bash
ls -l index.html
```

* **Commit log:**

```bash
git log --oneline | head -5
```

* **Remote confirmation:**

```bash
git ls-remote dev_media
```

---

## Final Status

* ✅ New remote `dev_media` added successfully.
* ✅ `index.html` copied, staged, committed to `master`.
* ✅ Changes pushed to `/opt/xfusioncorp_media.git` as required.
