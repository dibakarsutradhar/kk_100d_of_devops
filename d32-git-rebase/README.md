# 🧾 Git Rebase Report

**Task:** Rebase `feature` branch with `master` (without merge commit)
**Repository:** `/usr/src/kodekloudrepos/blog`
**Server:** `ststor01`
**User:** `natasha`

---

## 🧩 Task Summary

The Nautilus application development team required the `feature` branch to be rebased with the `master` branch to incorporate the latest updates without introducing a merge commit. The goal was to maintain a clean, linear Git history while keeping the `feature` branch up to date.

---

## 🧰 Steps Executed

### 1️⃣ Navigated to the Repository

```bash
cd /usr/src/kodekloudrepos/blog
```

### 2️⃣ Verified Current Branch and Commits

```bash
sudo git branch -a
sudo git log --oneline
```

**Output:**

```
7bbba03 (HEAD -> feature, origin/feature) Add new feature
3d2a65e initial commit
* feature
  master
  remotes/origin/feature
  remotes/origin/master
```

### 3️⃣ Fetched Latest Updates from Remote

```bash
sudo git fetch origin
```

### 4️⃣ Performed Rebase Operation

```bash
sudo git rebase master
```

✅ **Output:**

```
Successfully rebased and updated refs/heads/feature.
```

### 5️⃣ Verified Status After Rebase

```bash
sudo git status
```

✅ **Output:**

```
On branch feature
nothing to commit, working tree clean
```

### 6️⃣ Pushed Rebases Changes to Remote

```bash
sudo git push origin feature --force
```

*(Rebase rewrites history, so `--force` ensures the remote is updated.)*

---

## 🧾 Verification

### Commit Log After Rebase

```bash
sudo git log --oneline --graph --decorate --all
```

**Expected Output:**

```
* 7bbba03 (HEAD -> feature, origin/feature) Add new feature
* 3d2a65e (origin/master, master) initial commit
```

---

## 📸 Figures

*(Replace these with actual screenshots if required for submission.)*

* **Figure 1:** Branch overview before rebase
  `![Figure 1 – Branch Overview](path/to/screenshot1.png)`

* **Figure 2:** Successful rebase confirmation
  `![Figure 2 – Rebase Confirmation](path/to/screenshot2.png)`

* **Figure 3:** Clean commit history after rebase
  `![Figure 3 – Linear Commit Graph](path/to/screenshot3.png)`

---

## ✅ Final Result

* The **`feature`** branch was successfully rebased onto **`master`**.
* No merge commits were created.
* The Git history remains linear and clean.
* All changes were preserved and synchronized with the remote repository.
