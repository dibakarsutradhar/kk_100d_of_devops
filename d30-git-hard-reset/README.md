# 🧾 Git Repository Reset Report

**Task Name:** Clean up commit history for `/usr/src/kodekloudrepos/games` repository

**Server:** Storage Server (`ststor01`)
**User:** `natasha`

---

## 🧩 Task Summary

The Nautilus application development team wanted to **clean the Git commit history** of the `/usr/src/kodekloudrepos/games` repository.
They required the repository to retain **only two commits**:

1. `initial commit`
2. `add data.txt file`

All other commits and changes needed to be removed, and the changes pushed to the remote repository.

---

## 🧰 Steps Performed

### 1️⃣ Navigated to Repository

```bash
cd /usr/src/kodekloudrepos/games
```

### 2️⃣ Verified Commit History

Checked the existing commit log before resetting:

```bash
sudo git log --oneline
```

### 3️⃣ Identified Target Commit

Located the commit with message:

```
add data.txt file
```

Commit hash: `1d4d12c`

### 4️⃣ Reset Repository to Target Commit

Performed a **hard reset** to revert the working tree and branch pointer:

```bash
sudo git reset --hard 1d4d12c
```

✅ Output:

```
HEAD is now at 1d4d12c add data.txt file
```

### 5️⃣ Verified Post-Reset History

Confirmed that only the two required commits remain:

```bash
sudo git log --oneline
```

Output:

```
1d4d12c (HEAD -> master) add data.txt file
6e08add initial commit
```

### 6️⃣ Force Pushed to Remote Repository

To sync local history with the remote:

```bash
sudo git push origin master --force
```

---

## 🧾 Final Verification

Confirmed the remote branch now reflects the same two commits:

```bash
sudo git log --oneline origin/master
```

✅ Remote matches local:

```
1d4d12c add data.txt file
6e08add initial commit
```

---

## 📸 Figures

* **Figure 1:** Screenshot of local commit log after reset
  ![Figure 1 – Git Log After Reset](path/to/screenshot1.png)

* **Figure 2:** Screenshot after successful force push to remote
  ![Figure 2 – Push Confirmation](path/to/screenshot2.png)

---

## ✅ Result

The `/usr/src/kodekloudrepos/games` repository has been successfully cleaned and now contains only the two required commits:

* **initial commit**
* **add data.txt file**

All redundant commits have been removed both locally and remotely.

---
